{
  config,
  pkgs,
  lib,

  constants,
  ...
}:

let
  inherit (extraLib) mkEnable writeNushellScript;
  inherit (lib)
    options
    types
    modules
    ;
in

{
  options.gameSavesBackup = {
    enable = mkEnable;

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
      localCfg = cfg.gameSavesBackup;
    in
    modules.mkIf localCfg.enable {
      systemd.services."restic-gamesaves" = {
        serviceConfig = {
          Type = "oneshot";
          User = "root";

          ExecStart = writeNushellScript {
            name = "ludusavi-restic";
            text = ''
              # Running as user is required here as otherwise ludusavi can't find any games
              sudo -H -u ${constants.user} ludusavi backup --preview --api
              | from json
              | get games
              | items {|game, info|
                let paths = $info.files | columns

              	rustic --password-file ${cfg.passwordFile} --repo ${cfg.repo} backup ...$paths --tag gamesave --tag ($game | str kebab-case) --label $"Game save: ($game)" --group-by host,tags --skip-identical-parent
                
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

      systemd.timers."restic-gamesaves" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = cfg.timer;
          Persistent = true;
          Unit = "restic-gamesaves.service";
          RandomizedDelaySec = modules.mkIf (localCfg.randomDelay != null) localCfg.randomDelay;
        };
      };
    };
}
