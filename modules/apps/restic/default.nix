{
  config,
  pkgs,
  constants,
  lib,
  extraLib,
  ...
}:

let
  inherit (extraLib) mkBoolDefaultFalse;
  inherit (constants) user;
  inherit (lib)
    options
    types
    modules
    strings
    lists
    ;
in

{
  imports = [ ./cold.nix ];

  options.restic = {
    enable = mkBoolDefaultFalse;

    repo = options.mkOption {
      type = types.path;
    };

    passwordFile = options.mkOption {
      type = types.path;
    };

    simpleBackups = options.mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            path = options.mkOption {
              type = types.path;
            };

            timer = options.mkOption {
              type = types.str;
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

            # https://nixos.wiki/wiki/Systemd/Timers
            # https://wiki.archlinux.org/title/Systemd/Timers
            # https://unix.stackexchange.com/questions/126786/systemd-timer-every-15-minutes
          };
        }
      );
      default = { };
    };
  };

  config =
    let
      cfg = config.restic;

      commands = {
        # restic = "RESTIC_PASSWORD=$(sudo cat ${cfg.passwordFile}) restic --repo ${cfg.repo}";
        # rustic = "RUSTIC_PASSWORD=$(sudo cat ${cfg.passwordFile}) rustic --repo ${cfg.repo}";
        restic = "restic --password-file ${cfg.passwordFile} --repo ${cfg.repo}";
        rustic = "rustic --password-file ${cfg.passwordFile} --repo ${cfg.repo}";
      };
    in
    modules.mkIf cfg.enable {
      home-manager.users.${user} = {
        home.packages = with pkgs; [
          sshpass
          restic
          rustic
        ];

        home.shellAliases = {
          # Add aliases for the main repo
          restic2 = commands.restic;
          rustic2 = commands.rustic;
        };
      };

      systemd.services = lib.mapAttrs' (
        name: backup:
        lib.nameValuePair "restic-autobackup-${name}" {
          script =
            let
              tags =
                if lists.length backup.tags > 0 then "--tag " + strings.concatStringsSep "," backup.tags else "";
              displayPath = if backup.displayPath != null then "--as-path " + backup.displayPath else "";
              label = if backup.label != null then "--label " + backup.label else "";
            in
            ''
              ${commands.rustic} backup ${backup.path} ${tags} ${displayPath} ${label}
            '';

          serviceConfig = {
            Type = "oneshot";
            User = "root";
          };
        }
      ) cfg.simpleBackups;

      systemd.timers = lib.mapAttrs' (
        name: backup:
        lib.nameValuePair "restic-autobackup-${name}" {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = backup.timer;
            Persistent = true;
            Unit = "restic-autobackup-${name}.service";
          };
        }
      ) cfg.simpleBackups;

      environment.variables = {
        # RESTIC_STORAGE_BOX_ADDR_FILE = config.age.secrets."restic/storage-box-addr".path;
        # RESTIC_STORAGE_BOX_PWD_FILE = config.age.secrets."restic/storage-box-pwd".path;

        # RESTIC_REPO_HOT = constants.resticRepoHot;
        # RESTIC_REPO_COLD = constants.resticRepoCold or "";
      };
    };
}
