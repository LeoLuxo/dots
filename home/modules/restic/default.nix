{
  config,
  pkgs,
  lib,
  lib2,
  ...
}:

let
  inherit (lib) types;
  inherit (lib2) mkAttrs;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf;

  cfg = config.restic;
in

{
  imports = [
    ./checks.nix
    ./ludusavi.nix
    ./replication.nix
  ];

  options.restic = {
    enable = mkEnableOption "restic backup management" // {
      default = true;
    };

    repo = mkOption {
      description = "the path to the restic repo";
      type = types.path;
    };

    passwordFile = mkOption {
      description = "the path to a file containing the password of the repo";
      type = types.str;
    };

    notifyOnFail =
      mkEnableOption "sending desktop notifications in case of failures during backups/checks/etc"
      // {
        default = true;
      };

    backups = mkAttrs {
      description = "the backups to perform automatically";
      default = { };

      options = {
        path = mkOption {
          description = "the path to back up";
          type = types.path;
        };

        timer = mkOption {
          description = "the timer (see https://wiki.archlinux.org/title/Systemd/Timers) that dictates how often to back up";
          type = types.str;
        };

        randomDelay = mkOption {
          description = "a random delay added to the timer to avoid clashing with simulatenous other backups";
          type = types.nullOr types.str;
          default = null;
        };

        glob = mkOption {
          description = "the glob include/exclude options for the backup; defaults to inclusion, use !<path> to exclude";
          type = types.listOf types.str;
          default = [ ];
        };

        iglob = mkOption {
          description = "same as glob, but case-insensitive";
          type = types.listOf types.str;
          default = [ ];
        };

        tags = mkOption {
          description = "the tags to tag the backed-up snapshot with";
          type = types.listOf types.str;
          default = [ ];
        };

        displayPath = mkOption {
          description = "the display path (rustic's --as-path flag) of the backed-up snapshot";
          type = types.nullOr types.str;
          default = null;
        };

        label = mkOption {
          description = "the label of the backed-up snapshot";
          type = types.nullOr types.str;
          default = null;
        };
      };
    };
  };

  config = mkIf cfg.enable (
    let
      makeScript =
        backup:
        pkgs.writeShellScript backup.label (
          let
            tags = lib.concatMapStringsSep " " (x: ''--tag "${x}"'') backup.tags;
            displayPath = if backup.displayPath != null then ''--as-path "${backup.displayPath}"'' else "";
            label = if backup.label != null then ''--label "${backup.label}"'' else "";
            globs = lib.concatMapStringsSep " " (x: ''--glob "${x}"'') backup.glob;
            iglobs = lib.concatMapStringsSep " " (x: ''--iglob "${x}"'') backup.iglob;
          in
          ''
            ${lib.getExe pkgs.rustic} --no-progress --repo "${cfg.repo}" --password-file "${cfg.passwordFile}" backup ${backup.path} ${tags} ${displayPath} ${label} ${globs} ${iglobs} --group-by host,tags --exclude-if-present CACHEDIR.TAG --iglob "!.direnv"
          ''
        );
    in
    {
      home.packages = with pkgs; [
        sshpass
        restic
        rustic
      ];

      home.shellAliases = lib.mkMerge (
        [
          {
            # Add aliases for the main repo
            restic-main = ''${lib.getExe pkgs.restic} --repo "${cfg.repo}" --password-file "${cfg.passwordFile}"'';
            rustic-main = ''${lib.getExe pkgs.rustic} --repo "${cfg.repo}" --password-file "${cfg.passwordFile}"'';
            restic-main-autobackup-ALL = lib.concatMapAttrsStringSep "\n" (
              _: backup: "${makeScript backup}"
            ) cfg.backups;
          }
        ]
        ++ (lib.mapAttrsToList (name: backup: {
          "restic-main-autobackup-${name}" = "${makeScript backup}";
        }) cfg.backups)
      );

      systemd.user = lib.mkMerge (
        lib.mapAttrsToList (name: backup: {
          # Services for each of the local backups
          services."restic-autobackup-${name}" = {
            Service.ExecStart = makeScript backup;
            Unit.OnFailure = mkIf cfg.notifyOnFail [ "restic-autobackup-${name}-failed.service" ];
          };

          # Timers for each of the local backups
          timers."restic-autobackup-${name}" = {
            Timer = {
              OnCalendar = backup.timer;
              Persistent = true;
              Unit = "restic-autobackup-${name}.service";
              RandomizedDelaySec = mkIf (backup.randomDelay != null) backup.randomDelay;
            };

            Install.WantedBy = [ "timers.target" ];
          };

          # Notification services in case of failure for each of the local backups
          services."restic-autobackup-${name}-failed" = mkIf cfg.notifyOnFail {
            Service = {
              ExecStart = ''
                ${pkgs.libnotify}/bin/notify-send --urgency=critical \
                  "Backup failed for '${name}'" \
                  "$(journalctl -u restic-autobackup-${name} -n 5 -o cat)"
              '';

              Type = "oneshot";
            };
          };

        }) cfg.backups
      );
    }
  );
}
