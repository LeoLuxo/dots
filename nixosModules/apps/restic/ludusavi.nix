{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib) types;

  cfg = config.ext.apps.restic.gameSavesBackup;
in
{
  options.ext.apps.restic.gameSavesBackup = with lib2.options; {
    enable = lib.mkEnableOption "ludusavi game saves auto-backups";

    timer = mkOpt' "the interval with which to backup" types.str;

    randomDelay = mkNullOr "the optional random delay to add to the interval" types.str;
  };

  config = lib.mkIf cfg.enable {

    systemd.services."restic-gamesaves" = {
      serviceConfig = {
        Type = "oneshot";
        User = "root";

        ExecStart = pkgs.writeNushellScript {
          name = "ludusavi-restic";
          text = ''
            # Running as user is required here as otherwise ludusavi can't find any games
            sudo -H -u ${config.ext.system.user.name} ludusavi backup --preview --api
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

    systemd.timers."restic-gamesaves" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.timer;
        Persistent = true;
        Unit = "restic-gamesaves.service";
        RandomizedDelaySec = lib.mkIf (cfg.randomDelay != null) cfg.randomDelay;
      };
    };
  };
}
