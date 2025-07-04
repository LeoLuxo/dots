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
    ;
in

{
  options.restic.periodicChecks = {
    enable = mkBoolDefaultFalse;

    timer = options.mkOption {
      type = types.str;
    };

    randomDelay = options.mkOption {
      type = types.nullOr types.str;
      default = null;
    };

    readData = options.mkOption {
      type = types.either types.bool types.str;
      default = false;
    };

    cleanupCache = options.mkOption {
      type = types.either types.bool;
      default = false;
    };
  };

  config =
    let
      cfg = config.restic.periodicChecks;
    in
    modules.mkIf cfg.enable {
      systemd.services."restic-checks" =
        let
          readData = if cfg.readData != false then "--read-data" else "";
          readDataSubset = if lib.isString cfg.readData then ''--read-data-subset "${cfg.readData}"'' else "";
          cleanupCache = if cfg.cleanupCache then ''--cleanup-cache'' else "";
        in
        {

          # Running as user to catch errors due to files with root permissions contaminating the repo
          script = ''
            sudo --user=${config.my.system.user.name} --set-home \
              RESTIC_PASSWORD=$(cat ${cfg.passwordFile}) \
              restic --repo ${cfg.repo} check ${readData} ${readDataSubset} ${cleanupCache}
          '';

          path = [
            pkgs.restic
            "/run/wrappers" # for sudo
          ];

          serviceConfig = {
            Type = "oneshot";
            User = "root";
          };

          onFailure = lib.mkIf config.restic.notifyOnFail [ "restic-checks-failed.service" ];
        };

      systemd.timers."restic-checks" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = cfg.timer;
          Persistent = true;
          Unit = "restic-checks.service";
          RandomizedDelaySec = modules.mkIf (cfg.randomDelay != null) cfg.randomDelay;
        };
      };

      systemd.services."restic-checks-failed" = lib.mkIf config.restic.notifyOnFail {
        enable = true;
        serviceConfig = {
          Type = "oneshot";
          User = config.my.system.user.name;
        };

        # Required for notify-send
        environment.DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/${builtins.toString config.my.system.user.uid}/bus";

        script = ''
          ${pkgs.libnotify}/bin/notify-send --urgency=critical \
            "Restic periodic checks failed" \
            "$(journalctl -u restic-checks-failed -n 5 -o cat)"
        '';
      };
    };
}
