{
  config,
  pkgs,
  lib,
  extraLib,
  ...
}:

let
  inherit (lib) types;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf;
  inherit (extraLib) writeNushellScript;

  cfg = config.my.apps.restic.backupPresets.ludusavi;
  cfgRestic = config.my.apps.restic;
in

{
  options.my.apps.restic.backupPresets.ludusavi = {
    enable = mkEnableOption "automatic backups of all game saves through ludusavi";

    timer = mkOption {
      description = "the timer (see https://wiki.archlinux.org/title/Systemd/Timers) that dictates how often to back up";
      type = types.str;
    };

    randomDelay = mkOption {
      description = "a random delay added to the timer to avoid clashing with simulatenous other backups";
      type = types.nullOr types.str;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services."restic-ludusavi" = {
      serviceConfig = {
        ExecStart = writeNushellScript {
          name = "ludusavi-restic";
          text = ''
            # Running as user is required here as otherwise ludusavi can't find any games
            ludusavi backup --preview --api
            | from json
            | get games
            | items {|game, info|
              let paths = $info.files | columns

              rustic --repo "${cfgRestic.repo}" --password-file "${cfgRestic.passwordFile}" backup ...$paths --tag gamesave --tag ($game | str kebab-case) --label $"Game save: ($game)" --group-by host,tags --skip-identical-parent
              
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

      onFailure = mkIf cfgRestic.notifyOnFail [ "restic-ludusavi-failed.service" ];
    };

    systemd.user.timers."restic-ludusavi" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.timer;
        Persistent = true;
        Unit = "restic-ludusavi.service";
        RandomizedDelaySec = mkIf (cfg.randomDelay != null) cfg.randomDelay;
      };
    };

    systemd.user.services."restic-ludusavi-failed" = mkIf cfgRestic.notifyOnFail {
      script = ''
        ${pkgs.libnotify}/bin/notify-send --urgency=critical \
          "Restic ludusavi backup failed" \
          "$(journalctl -u restic-ludusavi-failed -n 5 -o cat)"
      '';
    };
  };
}
