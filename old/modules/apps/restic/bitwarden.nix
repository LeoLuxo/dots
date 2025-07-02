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

          export BW_CLIENTID=$(cat ${cfg.bwClientIDFile})
          export BW_CLIENTSECRET=$(cat ${cfg.bwClientSecretFile})
          OUT=$(mktemp --directory)

          alias bw='bw --nointeraction --cleanexit'

          bw login --apikey
          export BW_SESSION=$(bw unlock --passwordfile ${cfg.bwPasswordFile} --raw)

          bw export --output "$OUT/passwords.zip" --format zip
          bw export --output "$OUT/passwords.csv" --format csv
          bw export --output "$OUT/passwords.json" --format json
          bw export --output "$OUT/passwords_encrypted.json" --format encrypted_json

          bw lock
          bw logout

          7z a "$OUT/passwords.7z" "$OUT/*" -p"$(sudo cat ${cfg.bwPasswordFile})"

          rustic --password-file ${config.restic.passwordFile} --repo ${config.restic.repo} backup "$OUT/passwords.7z" --tag passwords --tag bitwarden --label $"Passwords (Bitwarden)" --group-by host,tags --skip-identical-parent

          rm -rf "$OUT"
          rm -rf "/root/.config/Bitwarden CLI"
        '';

        path = [
          pkgs.bitwarden-cli
          pkgs.rustic
          pkgs.p7zip
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
