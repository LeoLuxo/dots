{
  config,
  pkgs,
  lib,
  extraLib,
  ...
}:

let
  inherit (extraLib) mkBoolDefaultFalse;

  inherit (lib)
    options
    types
    modules
    strings
    lists
    ;
in

{
  imports = [
    ./cold.nix
    ./ludusavi.nix
  ];

  options.restic = {
    enable = mkBoolDefaultFalse;

    repo = options.mkOption {
      type = types.path;
    };

    passwordFile = options.mkOption {
      type = types.path;
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

    notifyOnFail = options.mkOption {
      type = types.bool;
      default = true;
    };

    # replications = options.mkOption {
    #   type = types.attrsOf (
    #     types.submodule {
    #       options = {
    #         path = options.mkOption {
    #           type = types.path;
    #         };

    #         timer = options.mkOption {
    #           type = types.str;
    #         };

    #         randomDelay = options.mkOption {
    #           type = types.nullOr types.str;
    #           default = null;
    #         };
    #       };
    #     }
    #   );
    #   default = { };
    # };
  };

  config =
    let
      cfg = config.restic;
    in
    modules.mkIf cfg.enable {
      my.packages = with pkgs; [
        sshpass
        restic
        rustic
      ];

      home-manager.users.${config.my.system.user.name} = {
        home.shellAliases = {
          # Add aliases for the main repo
          restic-main = "RESTIC_PASSWORD=$(sudo cat ${cfg.passwordFile}) restic --repo ${cfg.repo}";
          rustic-main = "RUSTIC_PASSWORD=$(sudo cat ${cfg.passwordFile}) rustic --repo ${cfg.repo}";
        };
      };

      systemd = lib.mkMerge (
        lib.mapAttrsToList (name: backup: {
          services."restic-autobackup-${name}" = {
            script =
              let
                tags =
                  if lists.length backup.tags > 0 then ''--tag ${strings.concatStringsSep "," backup.tags}'' else "";
                displayPath = if backup.displayPath != null then ''--as-path "${backup.displayPath}"'' else "";
                label = if backup.label != null then ''--label "${backup.label}"'' else "";
              in
              ''
                # Running as root so we can read the password file directly
                rustic --password-file ${cfg.passwordFile} --repo ${cfg.repo} backup ${backup.path} ${tags} ${displayPath} ${label} --group-by host,tags --skip-identical-parent --exclude-if-present CACHEDIR.TAG --iglob "!.direnv"
              '';

            path = [ pkgs.rustic ];

            serviceConfig = {
              Type = "oneshot";
              User = "root";
            };

            onFailure = lib.mkIf cfg.notifyOnFail [ "restic-autobackup-${name}-failed-notification.service" ];
          };

          timers."restic-autobackup-${name}" = {
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnCalendar = backup.timer;
              Persistent = true;
              Unit = "restic-autobackup-${name}.service";
              RandomizedDelaySec = modules.mkIf (backup.randomDelay != null) backup.randomDelay;
            };

            # https://nixos.wiki/wiki/Systemd/Timers
            # https://wiki.archlinux.org/title/Systemd/Timers
          };

          services."restic-autobackup-${name}-failed-notification" = lib.mkIf cfg.notifyOnFail {
            enable = true;
            description = "Notify on failed backup for ${name}";
            serviceConfig = {
              Type = "oneshot";
              User = config.my.system.user.name;
            };

            # required for notify-send
            environment.DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/%U/bus";

            script = ''
              ${pkgs.libnotify}/bin/notify-send --urgency=critical \
                "Backup failed for '${name}'" \
                "$(journalctl -u restic-autobackup-${name} -n 5 -o cat)"
            '';
          };

        }) cfg.backups
      );

      environment.variables = {
        RESTIC_STORAGE_BOX_ADDR_FILE = config.age.secrets."restic/storage-box-addr".path;
        RESTIC_STORAGE_BOX_PWD_FILE = config.age.secrets."restic/storage-box-pwd".path;

        # RESTIC_REPO_HOT = constants.resticRepoHot;
        # RESTIC_REPO_COLD = constants.resticRepoCold or "";
      };
    };
}
