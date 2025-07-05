{
  config,
  pkgs,
  lib,
  extraLib,
  ...
}:

let
  inherit (extraLib) mkBoolDefaultFalse;

  inherit (lib) options types;
in

{
  imports = [
    ./bitwarden.nix
    ./checks.nix
    ./ludusavi.nix
    ./replication.nix
  ];

  options.restic = {
    enable = mkBoolDefaultFalse;

    repo = options.mkOption {
      type = types.path;
    };

    passwordFile = options.mkOption {
      type = types.path;
    };

    notifyOnFail = options.mkOption {
      type = types.bool;
      default = true;
    };

    backups = options.mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            path = options.mkOption {
              type = types.path;
            };

            timer = options.mkOption {
              type = types.str;
            };

            randomDelay = options.mkOption {
              type = types.nullOr types.str;
              default = null;
            };

            glob = options.mkOption {
              type = types.listOf types.str;
              default = [ ];
            };

            iglob = options.mkOption {
              type = types.listOf types.str;
              default = [ ];
            };

            tags = options.mkOption {
              type = types.listOf types.str;
              default = [ ];
            };

            displayPath = options.mkOption {
              type = types.nullOr types.str;
              default = null;
            };

            label = options.mkOption {
              type = types.nullOr types.str;
              default = null;
            };
          };
        }
      );
      default = { };
    };
  };

  config =
    let
      cfg = config.restic;
    in
    lib.mkIf cfg.enable {
      my.packages = with pkgs; [
        sshpass
        restic
        rustic
      ];

      home-manager.users.${config.my.system.user.name} = {
        home.shellAliases = {
          # Add aliases for the main repo
          restic-main = ''${lib.getExe pkgs.restic} --repo "${cfg.repo}" --password-file "${cfg.passwordFile}"'';
          rustic-main = ''${lib.getExe pkgs.rustic} --repo "${cfg.repo}" --password-file "${cfg.passwordFile}"'';
        };
      };

      systemd.user = lib.mkMerge (
        lib.mapAttrsToList (name: backup: {
          # Services for each of the local backups
          services."restic-autobackup-${name}" = {
            path = [
              pkgs.rustic
            ];

            script =
              let
                tags = lib.concatMapStringsSep " " (x: ''--tag "${x}"'') backup.tags;
                displayPath = if backup.displayPath != null then ''--as-path "${backup.displayPath}"'' else "";
                label = if backup.label != null then ''--label "${backup.label}"'' else "";
                globs = lib.concatMapStringsSep " " (x: ''--glob "${x}"'') backup.glob;
                iglobs = lib.concatMapStringsSep " " (x: ''--iglob "${x}"'') backup.iglob;
              in
              ''
                rustic --no-progress --repo "${cfg.repo}" --password-file "${cfg.passwordFile}" backup ${backup.path} ${tags} ${displayPath} ${label} ${globs} ${iglobs} --group-by host,tags --skip-identical-parent --exclude-if-present CACHEDIR.TAG --iglob "!.direnv"
              '';

            onFailure = lib.mkIf cfg.notifyOnFail [ "restic-autobackup-${name}-failed.service" ];
          };

          # Timers for each of the local backups
          timers."restic-autobackup-${name}" = {
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnCalendar = backup.timer;
              Persistent = true;
              Unit = "restic-autobackup-${name}.service";
              RandomizedDelaySec = lib.mkIf (backup.randomDelay != null) backup.randomDelay;
            };

            # https://nixos.wiki/wiki/Systemd/Timers
            # https://wiki.archlinux.org/title/Systemd/Timers
          };

          # Notification services in case of failure for each of the local backups
          services."restic-autobackup-${name}-failed" = lib.mkIf cfg.notifyOnFail {
            script = ''
              ${pkgs.libnotify}/bin/notify-send --urgency=critical \
                "Backup failed for '${name}'" \
                "$(journalctl -u restic-autobackup-${name} -n 5 -o cat)"
            '';
          };

        }) cfg.backups
      );
    };
}
