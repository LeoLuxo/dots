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
  options.restic.backupPresets.bitwarden = {
    enable = mkBoolDefaultFalse;

    timer = options.mkOption {
      type = types.str;
    };

    randomDelay = options.mkOption {
      type = types.nullOr types.str;
      default = null;
    };

    bwClientIDFile = options.mkOption {
      type = types.path;
    };

    bwClientSecretFile = options.mkOption {
      type = types.path;
    };

    bwPasswordFile = options.mkOption {
      type = types.path;
    };
  };

  config =
    let
      cfg = config.restic.backupPresets.bitwarden;
    in
    modules.mkIf cfg.enable {
      systemd.services."restic-bitwarden" = {
        script = ''
          rm -rf "/root/.config/Bitwarden CLI"

          BW_CLIENTID=$(cat ${cfg.bwClientIDFile})
          BW_CLIENTSECRET=$(cat ${cfg.bwClientSecretFile})
          OUT=$(mktemp --directory)

          bw --nointeraction --cleanexit login --apikey
          bw --nointeraction --cleanexit status
          BW_SESSION=$(bw --nointeraction --cleanexit unlock --passwordfile ${cfg.bwPasswordFile} --raw)

          bw --nointeraction --cleanexit export --output "$OUT/passwords.json" --format encrypted_json
          bw --nointeraction --cleanexit export --output "$OUT/passwords.json" --format json
          bw --nointeraction --cleanexit export --output "$OUT/passwords.csv" --format csv
          bw --nointeraction --cleanexit export --output "$OUT/passwords.zip" --format zip

          bw lock
          bw logout

          rustic --password-file ${config.restic.passwordFile} --repo ${config.restic.repo} backup "$OUT" --tag passwords --tag bitwarden --label $"Passwords (Bitwarden)" --group-by host,tags --skip-identical-parent

          rm -rf "$OUT"
          rm -rf "/root/.config/Bitwarden CLI"
        '';

        path = [
          pkgs.bitwarden-cli
          pkgs.rustic
        ];

        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };

      systemd.timers."restic-bitwarden" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = cfg.timer;
          Persistent = true;
          Unit = "restic-bitwarden.service";
          RandomizedDelaySec = modules.mkIf (cfg.randomDelay != null) cfg.randomDelay;
        };
      };
    };
}
