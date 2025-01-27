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
  options.restic.gameSavesBackup = {
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
      cfg = config.restic.gameSavesBackup;
    in
    modules.mkIf cfg.enable {
      systemd.services."restic-gamesaves" = {
        serviceConfig = {
          Type = "oneshot";
          User = "root";
          ExecStart = writeNushellScript {
            name = "ludusavi-restic";
            text = ''
              ludusavi backup --preview --api
              | from json
              | get games
              | items {|game, info|
                let paths = $info.files | columns

              	rustic --password-file ${config.restic.passwordFile} --repo ${config.restic.repo} backup ...$paths --tag gamesave --tag ($game | str kebab-case) --label $"Game save: ($game)" --group-by host,tags --skip-identical-parent
                
                echo $game
              }
            '';
            deps = [
              pkgs.ludusavi
              pkgs.rustic
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
          RandomizedDelaySec = modules.mkIf (cfg.randomDelay != null) cfg.randomDelay;
        };
      };
    };
}
