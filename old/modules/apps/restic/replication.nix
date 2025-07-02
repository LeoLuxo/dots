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

                remotePort = options.mkOption {
                  type = types.port;
                  default = 23;
                };

                remoteAddressFile = options.mkOption {
                  type = types.path;
                };

                remotePasswordFile = options.mkOption {
                  type = types.path;
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
                type = types.nullOr types.string;
                default = null;
              };
              keepHourly = lib.mkOption {
                type = types.nullOr types.string;
                default = null;
              };
              keepDaily = lib.mkOption {
                type = types.nullOr types.string;
                default = null;
              };
              keepWeekly = lib.mkOption {
                type = types.nullOr types.string;
                default = null;
              };
              keepMonthly = lib.mkOption {
                type = types.nullOr types.string;
                default = null;
              };
              keepYearly = lib.mkOption {
                type = types.nullOr types.string;
                default = null;
              };
              keepWithin = lib.mkOption {
                type = types.nullOr types.string;
                default = null;
              };
              keepWithinHourly = lib.mkOption {
                type = types.nullOr types.string;
                default = null;
              };
              keepWithinDaily = lib.mkOption {
                type = types.nullOr types.string;
                default = null;
              };
              keepWithinWeekly = lib.mkOption {
                type = types.nullOr types.string;
                default = null;
              };
              keepWithinMonthly = lib.mkOption {
                type = types.nullOr types.string;
                default = null;
              };
              keepWithinYearly = lib.mkOption {
                type = types.nullOr types.string;
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
        systemd.services."restic-replication" = {
          script =
            let
              checkCommand =
                if cfg.replication.performFullCheck then
                  "restic --repo ${cfg.repo} --password-file ${cfg.passwordFile} check --read-data"
                else if cfg.replication.performQuickCheck then
                  "restic --repo ${cfg.repo} --password-file ${cfg.passwordFile} check"
                else
                  "";

              localCopiesCommands = lib.mapAttrsToList (_: localRepo: ''
                restic copy --from-repo ${cfg.repo} --from-password-file ${cfg.passwordFile} --repo ${localRepo.path} --password-file ${localRepo.passwordFile}
              '') cfg.replication.localRepos;

              remoteCopiesCommands = lib.mapAttrsToList (_: remoteRepo: ''
                export SSHPASS=$(cat ${remoteRepo.remotePasswordFile})
                ADDRESS=$(cat ${remoteRepo.remoteAddressFile})

                restic -o sftp.command="sshpass -v -e ssh -o StrictHostKeyChecking=no -p${builtins.toString remoteRepo.remotePort} $ADDRESS -s sftp" -r sftp:$ADDRESS:${remoteRepo.path} --password-file ${remoteRepo.passwordFile} copy --from-repo ${cfg.repo} --from-password-file ${cfg.passwordFile}
              '') cfg.replication.remoteRepos;
            in
            ''
              # Perform checks
              ${checkCommand}

              # Perform local copies
              ${lib.concatStringsSep "\n" localCopiesCommands}

              # Perform remote copies
              ${lib.concatStringsSep "\n" remoteCopiesCommands}

              # Forget
            '';

          path = [
            pkgs.restic
            pkgs.sshpass
          ];

          serviceConfig = {
            Type = "oneshot";
            User = "root";
          };

          onFailure = lib.mkIf cfg.notifyOnFail [ "restic-replication-failed.service" ];
        };

        systemd.timers."restic-replication" = {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = cfg.replication.timer;
            Persistent = true;
            Unit = "restic-replication.service";
            RandomizedDelaySec = lib.mkIf (cfg.replication.randomDelay != null) cfg.replication.randomDelay;
          };
        };

        systemd.services."restic-replication-failed" = lib.mkIf cfg.notifyOnFail {
          enable = true;
          serviceConfig = {
            Type = "oneshot";
            User = config.my.system.user.name;
          };

          # Required for notify-send
          environment.DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/${builtins.toString config.my.system.user.uid}/bus";

          script = ''
            ${pkgs.libnotify}/bin/notify-send --urgency=critical \
              "Restic replication failed" \
              "$(journalctl -u restic-replication-failed -n 5 -o cat)"
          '';
        };
      };
}
