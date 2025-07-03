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
          User = "root";

          ExecStart = writeNushellScript {
            name = "ludusavi-restic";
            text = ''
              # Running as user is required here as otherwise ludusavi can't find any games
              sudo -H -u ${config.my.system.user.name} ludusavi backup --preview --api
              | from json
              | get games
              | items {|game, info|
                let paths = $info.files | columns

              	rustic --password-file ${config.restic.passwordFile} --repo ${config.restic.repo} backup ...$paths --tag gamesave --tag ($game | str kebab-case) --label $"Game save: ($game)" --group-by host,tags --skip-identical-parent
                
                $game
              }
            '';
            deps = [
              pkgs.ludusavi
              pkgs.rustic
              "/run/wrappers"
            ];
            binFolder = false;
          };
        };
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
    };
}
