{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) options types;
in
{
  options.restic.replication = options.mkOption {
    type = types.submodule {
      options = {
        enable = options.mkOption {
          type = types.bool;
          default = false;
        };

        timer = options.mkOption {
          type = types.str;
        };

        randomDelay = options.mkOption {
          type = types.nullOr types.str;
          default = null;
        };

        performQuickCheck = options.mkOption {
          type = types.bool;
          default = true;
        };

        performFullCheck = options.mkOption {
          type = types.bool;
          default = false;
        };

        localRepos = options.mkOption {
          type = types.attrsOf (
            types.submodule {
              options = {
                path = options.mkOption {
                  type = types.str;
                };

                passwordFile = options.mkOption {
                  type = types.path;
                };
              };
            }
          );
        };

        remoteRepos = options.mkOption {
          type = types.attrsOf (
            types.submodule {
              options = {
                path = options.mkOption {
                  type = types.str;
                };

                passwordFile = options.mkOption {
                  type = types.path;
                };

                remoteAddressFile = options.mkOption {
                  type = types.path;
                };

                remotePort = options.mkOption {
                  type = types.nullOr types.port;
                  default = null;
                };

                privateKey = options.mkOption {
                  type = types.nullOr types.path;
                  default = null;
                };
              };
            }
          );
        };

        forget = options.mkOption {
          type = types.submodule {
            options = {
              enable = options.mkOption {
                type = types.bool;
                default = false;
              };

              prune = options.mkOption {
                type = types.bool;
                default = false;
              };

              keepLast = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
              };
              keepHourly = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
              };
              keepDaily = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
              };
              keepWeekly = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
              };
              keepMonthly = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
              };
              keepYearly = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
              };
              keepWithin = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
              };
              keepWithinHourly = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
              };
              keepWithinDaily = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
              };
              keepWithinWeekly = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
              };
              keepWithinMonthly = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
              };
              keepWithinYearly = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
              };
            };
          };
        };
      };
    };
  };

  config =
    let
      cfg = config.restic;
    in
    lib.mkIf (cfg.enable && cfg.replication.enable)
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
                if cfg.replication.performFullCheck || cfg.replication.performQuickCheck then
                  ''restic --repo ${cfg.repo} --password-file "${cfg.passwordFile}" check''
                  + (if cfg.replication.performFullCheck then " --read-data" else "")
                else
                  "";

              localCopiesCommands = lib.mapAttrsToList (
                name: localRepo:
                ''restic --repo "${localRepo.path}" --password-file "${localRepo.passwordFile}" copy --from-repo "${cfg.repo}" --from-password-file "${cfg.passwordFile}"''
              ) cfg.replication.localRepos;

              remoteCopiesCommands = lib.mapAttrsToList (
                name: remoteRepo:
                let
                  specifiedPrivateKey = if remoteRepo.privateKey != null then "-i ${remoteRepo.privateKey}" else "";
                  specifiedPort =
                    if remoteRepo.remotePort != null then "-p ${builtins.toString remoteRepo.remotePort}" else "";
                in
                ''
                  restic --option sftp.args='${specifiedPort} ${specifiedPrivateKey} -o StrictHostKeyChecking=no' --repo "sftp:$(cat ${remoteRepo.remoteAddressFile}):${remoteRepo.path}" --password-file "${remoteRepo.passwordFile}" copy --from-repo "${cfg.repo}" --from-password-file "${cfg.passwordFile}"
                ''
              ) cfg.replication.remoteRepos;

              forgetCommand =
                let
                  cfgf = cfg.replication.forget;
                in
                if cfgf.enable then
                  ''restic --repo "${cfg.repo}" --password-file "${cfg.passwordFile}" forget --group-by host,tags ''
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

          onFailure = lib.mkIf cfg.notifyOnFail [ "restic-replication-failed.service" ];
        };

        systemd.user.timers."restic-replication" = {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = cfg.replication.timer;
            Persistent = true;
            Unit = "restic-replication.service";
            RandomizedDelaySec = lib.mkIf (cfg.replication.randomDelay != null) cfg.replication.randomDelay;
          };
        };

        systemd.user.services."restic-replication-failed" = lib.mkIf cfg.notifyOnFail {
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
          }) cfg.replication.localRepos)

          # Add aliases for each of the extra remote repos
          ++ (lib.mapAttrsToList (name: remoteRepo: {
            "restic-remote-${name}" =
              ''restic --repo "sftp:$(cat ${remoteRepo.remoteAddressFile}):${remoteRepo.path}" --password-file "${remoteRepo.passwordFile}" --option sftp.args='-p${builtins.toString remoteRepo.remotePort} -i ${remoteRepo.privateKey} -o StrictHostKeyChecking=no' '';

            # Can't have rustic alias as it doesn't have the -o flag
          }) cfg.replication.remoteRepos)
        );
      };
}
