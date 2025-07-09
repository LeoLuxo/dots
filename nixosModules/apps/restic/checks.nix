{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) types;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf;

  cfg = config.my.apps.restic.periodicChecks;
  cfgRestic = config.my.apps.restic;
in

{
  options.my.apps.restic.periodicChecks = {
    enable = mkEnableOption "automatic and periodic checking of the repo's health";

    timer = mkOption {
      description = "the timer (see https://wiki.archlinux.org/title/Systemd/Timers) that dictates how often to back up";
      type = types.str;
    };

    randomDelay = mkOption {
      description = "a random delay added to the timer to avoid clashing with simulatenous other backups";
      type = types.nullOr types.str;
      default = null;
    };

    readData = mkOption {
      description = "whether to read the data in the repo while checking. If true, reads the ENTIRE repo. If a string, reads a subset of data packs, specified as 'n/t' for specific part, or either 'x%' or 'x.y%' or a size in bytes with suffixes k/K, m/M, g/G, t/T for a random subset";
      type = types.either types.bool types.str;
      default = false;
    };

    cleanupCache = mkEnableOption "automatically clean up the cache while checking";
    cleanupStaleLocks = mkEnableOption "automatically clean up stale locks after checking" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    systemd.services."restic-checks" = {
      path = [
        pkgs.restic
      ];

      script =
        let
          readData = if cfg.readData != false then ''--read-data'' else "";
          readDataSubset = if lib.isString cfg.readData then ''--read-data-subset "${cfg.readData}"'' else "";
          cleanupCache = if cfg.cleanupCache then ''--cleanup-cache'' else "";

          cleanupStaleLocks =
            if cfg.cleanupStaleLocks then
              ''restic --repo "${cfgRestic.repo} "--password-file "${cfgRestic.passwordFile}" unlock''
            else
              "";
        in
        ''
          restic --repo "${cfgRestic.repo} "--password-file "${cfgRestic.passwordFile}" check ${readData} ${readDataSubset} ${cleanupCache}

          ${cleanupStaleLocks}
        '';

      onFailure = mkIf cfgRestic.notifyOnFail [ "restic-checks-failed.service" ];
    };

    systemd.timers."restic-checks" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.timer;
        Persistent = true;
        Unit = "restic-checks.service";
        RandomizedDelaySec = mkIf (cfg.randomDelay != null) cfg.randomDelay;
      };
    };

    systemd.services."restic-checks-failed" = mkIf cfgRestic.notifyOnFail {
      script = ''
        ${pkgs.libnotify}/bin/notify-send --urgency=critical \
          "Restic periodic checks failed" \
          "$(journalctl -u restic-checks-failed -n 5 -o cat)"
      '';
    };
  };
}
