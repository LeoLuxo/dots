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

  cfg = config.my.apps.restic;
in
{
  options.my.apps.restic = with lib2.options; {
    enable = lib.mkEnableOption "restic";

    repo = mkOpt' "the path to the restic repository" types.path;

    passwordFile = mkOpt' "the path to the password file" types.path;

    backups = mkAttrsSub' "the list of automatic backups" {
      path = mkOpt' "the path to back up" types.path;
      timer = mkOpt' "the interval with which to backup" types.str;
      randomDelay = mkNullOr "the optional random delay to add to the interval" types.str;
      tags = mkOpt "the list of tags to tag the backup with" (types.listOf types.str) [ ];
      displayPath = mkNullOr "the custom display path for the backup" types.str;
      label = mkNullOr "the custom label for the backup" types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    my = {
      packages = with pkgs; [
        sshpass
        restic
        rustic
      ];

      shell.aliases = {
        # Add aliases for the main repo
        restic-main = "RESTIC_PASSWORD=$(sudo cat ${cfg.passwordFile}) restic --repo ${cfg.repo}";
        rustic-main = "RUSTIC_PASSWORD=$(sudo cat ${cfg.passwordFile}) rustic --repo ${cfg.repo}";
      };
    };

    systemd.services = lib.mapAttrs' (
      name: backup:
      lib.nameValuePair "restic-autobackup-${name}" {
        script =
          let
            tags = if lib.length backup.tags > 0 then ''--tag ${lib.concatStringsSep "," backup.tags}'' else "";
            displayPath = if backup.displayPath != null then ''--as-path "${backup.displayPath}"'' else "";
            label = if backup.label != null then ''--label "${backup.label}"'' else "";
          in
          ''
            # Running as root so we can read the password file directly
            rustic --password-file ${cfg.passwordFile} --repo ${cfg.repo} backup ${backup.path} ${tags} ${displayPath} ${label} --group-by host,tags --skip-identical-parent --exclude-if-present CACHEDIR.TAG --iglob "!.direnv"
          '';

        path = [ pkgs.rustic ];

        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      }
    ) cfg.backups;

    systemd.timers = lib.mapAttrs' (
      name: backup:
      lib.nameValuePair "restic-autobackup-${name}" {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = backup.timer;
          Persistent = true;
          Unit = "restic-autobackup-${name}.service";
          RandomizedDelaySec = lib.mkIf (backup.randomDelay != null) backup.randomDelay;
        };

        # https://nixos.wiki/wiki/Systemd/Timers
        # https://wiki.archlinux.org/title/Systemd/Timers
      }
    ) cfg.backups;

    environment.variables = {
      # RESTIC_STORAGE_BOX_ADDR_FILE = config.age.secrets."restic/storage-box-addr".path;
      # RESTIC_STORAGE_BOX_PWD_FILE = config.age.secrets."restic/storage-box-pwd".path;

      # RESTIC_REPO_HOT = constants.resticRepoHot;
      # RESTIC_REPO_COLD = constants.resticRepoCold or "";
    };
  };
}
