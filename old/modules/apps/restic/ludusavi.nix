{
  config,
  pkgs,
  lib,
  extraLib,
  ...
}:

let
  inherit (extraLib) mkBoolDefaultFalse writeNushellScript;
  inherit (lib)
    options
    types
    modules
    ;
in

{
  options.restic.backupPresets.ludusavi = {
    enable = mkBoolDefaultFalse;

    timer = options.mkOption {
      type = types.str;
    };

    randomDelay = options.mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };

  config =
    let
      cfg = config.restic.backupPresets.ludusavi;
    in
    modules.mkIf cfg.enable {
      systemd.services."restic-ludusavi" = {
        serviceConfig = {
          Type = "oneshot";
          User = config.my.system.user.name;
          LoadCredential = [ "repoPassword:${config.restic.passwordFile}" ];

          ExecStart = writeNushellScript {
            name = "ludusavi-restic";
            text = ''
              # Running as user is required here as otherwise ludusavi can't find any games
              ludusavi backup --preview --api
              | from json
              | get games
              | items {|game, info|
                let paths = $info.files | columns

                rustic --repo ${config.restic.repo} backup ...$paths --tag gamesave --tag ($game | str kebab-case) --label $"Game save: ($game)" --group-by host,tags --skip-identical-parent
                
                $game
              }
            '';

            deps = [
              pkgs.ludusavi
              pkgs.rustic
            ];

            binFolder = false;
          };
        };

        environment = {
          RESTIC_PASSWORD_FILE = "%d/repoPassword";
          RUSTIC_PASSWORD_FILE = "%d/repoPassword";
        };

        onFailure = lib.mkIf config.restic.notifyOnFail [ "restic-ludusavi-failed.service" ];
      };

      systemd.timers."restic-ludusavi" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = cfg.timer;
          Persistent = true;
          Unit = "restic-ludusavi.service";
          RandomizedDelaySec = modules.mkIf (cfg.randomDelay != null) cfg.randomDelay;
        };
      };

      systemd.services."restic-ludusavi-failed" = lib.mkIf config.restic.notifyOnFail {
        enable = true;
        serviceConfig = {
          Type = "oneshot";
          User = config.my.system.user.name;
        };

        # Required for notify-send
        environment.DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/${builtins.toString config.my.system.user.uid}/bus";

        script = ''
          ${pkgs.libnotify}/bin/notify-send --urgency=critical \
            "Restic ludusavi backup failed" \
            "$(journalctl -u restic-ludusavi-failed -n 5 -o cat)"
        '';
      };
    };
}
