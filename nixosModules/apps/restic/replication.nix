{
  config,
  pkgs,
  lib,
  ...
}:

let

  inherit (lib) types;
  inherit (lib.my) mkAttrs mkSubmodule;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf;

  cfg = config.my.apps.restic.replication;
  cfgRestic = config.my.apps.restic;
in

let
  mkKeepOption =
    description:
    mkOption {
      inherit description;
      type = types.nullOr types.str;
      default = null;
    };
in

{
  options.my.apps.restic.replication = {
    enable = mkEnableOption "automatic replication of the repo to other repos";

    timer = mkOption {
      description = "the timer (see https://wiki.archlinux.org/title/Systemd/Timers) that dictates how often to back up";
      type = types.str;
    };

    randomDelay = mkOption {
      description = "a random delay added to the timer to avoid clashing with simulatenous other backups";
      type = types.nullOr types.str;
      default = null;
    };

    performQuickCheck = mkOption {
      description = "whether to perform a quick check (without --read-data) of the repo before replicating";
      type = types.bool;
      default = true;
    };

    performFullCheck = mkOption {
      description = "whether to perform a full check (with --read-data) of the repo before replicating";
      type = types.bool;
      default = false;
    };

    localRepos = mkAttrs {
      description = "the local (same system) repos to replicate to";

      options = {
        path = mkOption {
          description = "the path to the local repo";
          type = types.str;
        };

        passwordFile = mkOption {
          description = "the password of the local repo";
          type = types.path;
        };
      };
    };

    remoteRepos = mkAttrs {
      description = "the remote/cloud repos to replicate to";

      options = {
        path = mkOption {
          description = "the path to the repo inside the remote";
          type = types.str;
        };

        passwordFile = mkOption {
          description = "the password of the remote repo";
          type = types.path;
        };

        remoteAddressFile = mkOption {
          description = "the path to a file containing the address of the remote";
          type = types.path;
        };

        remotePort = mkOption {
          description = "the port to connect to the remote with, set to null to unspecify and use ssh's default";
          type = types.nullOr types.port;
          default = null;
        };

        privateKey = mkOption {
          description = "the identity file to connect to the remote with; set to null to unspecify";
          type = types.nullOr types.path;
          default = null;
        };
      };
    };

    forget = mkSubmodule {
      enable = mkEnableOption "automatically forget snapshots after replicating";
      prune = mkEnableOption "automatically prune (i.e. delete and clean up) unused files from forgotten snapshots after replicating";

      keepLast = mkKeepOption "keep the last n snapshots (use 'unlimited' to keep all snapshots)";
      keepHourly = mkKeepOption "keep the last n hourly snapshots (use 'unlimited' to keep all hourly snapshots)";
      keepDaily = mkKeepOption "keep the last n daily snapshots (use 'unlimited' to keep all daily snapshots)";
      keepWeekly = mkKeepOption "keep the last n weekly snapshots (use 'unlimited' to keep all weekly snapshots)";
      keepMonthly = mkKeepOption "keep the last n monthly snapshots (use 'unlimited' to keep all monthly snapshots)";
      keepYearly = mkKeepOption "keep the last n yearly snapshots (use 'unlimited' to keep all yearly snapshots)";
      keepWithin = mkKeepOption "keep snapshots that are newer than duration (eg. 1y5m7d2h) relative to the latest snapshot";
      keepWithinHourly = mkKeepOption "keep hourly snapshots that are newer than duration (eg. 1y5m7d2h) relative to the latest snapshot";
      keepWithinDaily = mkKeepOption "keep daily snapshots that are newer than duration (eg. 1y5m7d2h) relative to the latest snapshot";
      keepWithinWeekly = mkKeepOption "keep weekly snapshots that are newer than duration (eg. 1y5m7d2h) relative to the latest snapshot";
      keepWithinMonthly = mkKeepOption "keep monthly snapshots that are newer than duration (eg. 1y5m7d2h) relative to the latest snapshot";
      keepWithinYearly = mkKeepOption "keep yearly snapshots that are newer than duration (eg. 1y5m7d2h) relative to the latest snapshot";
    };
  };

  config =
    mkIf (cfg.enable && cfg.enable)
      # Replication: periodically do checks & copy to other repos & forget old snapshots
      {
        systemd.user.services."restic-replication" = {
          path = [
            pkgs.restic
            pkgs.sshpass
            pkgs.openssh
          ];

          script =
            let
              checkCommand =
                if cfg.performFullCheck || cfg.performQuickCheck then
                  ''restic --repo ${cfgRestic.repo} --password-file "${cfgRestic.passwordFile}" check''
                  + (if cfg.performFullCheck then " --read-data" else "")
                else
                  "";

              localCopiesCommands = lib.mapAttrsToList (
                name: localRepo:
                ''restic --repo "${localRepo.path}" --password-file "${localRepo.passwordFile}" copy --from-repo "${cfgRestic.repo}" --from-password-file "${cfgRestic.passwordFile}"''
              ) cfg.localRepos;

              remoteCopiesCommands = lib.mapAttrsToList (
                name: remoteRepo:
                let
                  specifiedPrivateKey = if remoteRepo.privateKey != null then "-i ${remoteRepo.privateKey}" else "";
                  specifiedPort =
                    if remoteRepo.remotePort != null then "-p ${builtins.toString remoteRepo.remotePort}" else "";
                in
                ''
                  restic --option sftp.args='${specifiedPort} ${specifiedPrivateKey} -o StrictHostKeyChecking=no' --repo "sftp:$(cat ${remoteRepo.remoteAddressFile}):${remoteRepo.path}" --password-file "${remoteRepo.passwordFile}" copy --from-repo "${cfgRestic.repo}" --from-password-file "${cfgRestic.passwordFile}"
                ''
              ) cfg.remoteRepos;

              forgetCommand =
                let
                  cfgf = cfg.forget;
                in
                if cfgf.enable then
                  ''restic --repo "${cfgRestic.repo}" --password-file "${cfgRestic.passwordFile}" forget --group-by host,tags ''
                  + (if cfgf.prune then " --prune" else "")
                  + (if cfgf.keepHourly != null then " --keep-hourly ${cfgf.keepHourly}" else "")
                  + (if cfgf.keepLast != null then " --keep-last ${cfgf.keepLast}" else "")
                  + (if cfgf.keepDaily != null then " --keep-daily ${cfgf.keepDaily}" else "")
                  + (if cfgf.keepWeekly != null then " --keep-weekly ${cfgf.keepWeekly}" else "")
                  + (if cfgf.keepMonthly != null then " --keep-monthly ${cfgf.keepMonthly}" else "")
                  + (if cfgf.keepYearly != null then " --keep-yearly ${cfgf.keepYearly}" else "")
                  + (if cfgf.keepWithin != null then " --keep-within ${cfgf.keepWithin}" else "")
                  + (if cfgf.keepWithinHourly != null then " --keep-within-hourly ${cfgf.keepWithinHourly}" else "")
                  + (if cfgf.keepWithinDaily != null then " --keep-within-daily ${cfgf.keepWithinDaily}" else "")
                  + (if cfgf.keepWithinWeekly != null then " --keep-within-weekly ${cfgf.keepWithinWeekly}" else "")
                  + (
                    if cfgf.keepWithinMonthly != null then " --keep-within-monthly ${cfgf.keepWithinMonthly}" else ""
                  )
                  + (if cfgf.keepWithinYearly != null then " --keep-within-yearly ${cfgf.keepWithinYearly}" else "")
                else
                  "";
            in
            ''
              echo Performing checks
              ${checkCommand}

              echo Performing local copies
              ${lib.concatStringsSep "\n" localCopiesCommands}

              echo Performing remote copies
              ${lib.concatStringsSep "\n" remoteCopiesCommands}

              echo Forgetting snapshots
              ${forgetCommand}
            '';

          onFailure = mkIf cfgRestic.notifyOnFail [ "restic-replication-failed.service" ];
        };

        systemd.user.timers."restic-replication" = {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = cfg.timer;
            Persistent = true;
            Unit = "restic-replication.service";
            RandomizedDelaySec = mkIf (cfg.randomDelay != null) cfg.randomDelay;
          };
        };

        systemd.user.services."restic-replication-failed" = mkIf cfgRestic.notifyOnFail {
          script = ''
            ${pkgs.libnotify}/bin/notify-send --urgency=critical \
              "Restic replication failed" \
              "$(journalctl -u restic-replication-failed -n 5 -o cat)"
          '';
        };

        home-manager.users.${config.my.user.name}.home.shellAliases = lib.mkMerge (
          # Add aliases for each of the extra local repos
          (lib.mapAttrsToList (name: localRepo: {
            "restic-local-${name}" =
              ''${lib.getExe pkgs.restic} --repo "${localRepo.path}" --password-file "${localRepo.passwordFile}"'';

            "rustic-local-${name}" =
              ''${lib.getExe pkgs.rustic} --repo "${localRepo.path}" --password-file "${localRepo.passwordFile}"'';
          }) cfg.localRepos)

          # Add aliases for each of the extra remote repos
          ++ (lib.mapAttrsToList (
            name: remoteRepo:
            let
              specifiedPrivateKey = if remoteRepo.privateKey != null then "-i ${remoteRepo.privateKey}" else "";
              specifiedPort =
                if remoteRepo.remotePort != null then "-p ${builtins.toString remoteRepo.remotePort}" else "";
            in
            {
              "restic-remote-${name}" =
                ''restic --repo "sftp:$(cat ${remoteRepo.remoteAddressFile}):${remoteRepo.path}" --password-file "${remoteRepo.passwordFile}" --option sftp.args='${specifiedPort} ${specifiedPrivateKey}  -o StrictHostKeyChecking=no' '';

              # Can't have rustic alias as it doesn't have the --option flag afaik
            }
          ) cfg.remoteRepos)
        );
      };
}
