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
        serviceConfig = {
          Type = "oneshot";
          User = config.my.system.user.name;
          LoadCredential = [
            "repoPassword:${config.restic.passwordFile}"
            "bwClientID:${cfg.bwClientIDFile}"
            "bwClientSecret:${cfg.bwClientSecretFile}"
            "bwPassword:${cfg.bwPasswordFile}"
          ];
        };

        environment = {
          RESTIC_PASSWORD_FILE = "%d/repoPassword";
          RUSTIC_PASSWORD_FILE = "%d/repoPassword";
          BW_CLIENTID = "%d/bwClientID";
          BW_CLIENTSECRET = "%d/bwClientSecret";
        };

        path = [
          pkgs.bitwarden-cli
          pkgs.rustic
          pkgs.p7zip
        ];

        script = ''
          OUT=$(mktemp --directory)

          # --cleanexit makes it so the login and unlock commands don't error out if bitwarden is already logged-in or unlocked
          # Also for reference, bw (when running as root) seems to cache logins etc in here: "/root/.config/Bitwarden CLI"

          bw --nointeraction --cleanexit login --apikey
          export BW_SESSION=$(bw --nointeraction --cleanexit unlock --passwordfile "$CREDENTIALS_DIRECTORY/bwPassword" --raw)

          bw --nointeraction export --output "$OUT/passwords.zip" --format zip
          bw --nointeraction export --output "$OUT/passwords.csv" --format csv
          bw --nointeraction export --output "$OUT/passwords.json" --format json
          bw --nointeraction export --output "$OUT/passwords_encrypted.json" --format encrypted_json

          bw --nointeraction lock
          # Don't log out because otherwise I keep getting emails about a new login on every backup -.-
          # bw --nointeraction logout
          unset BW_SESSION

          7z a "$OUT/passwords.7z" "$OUT/*" -p"$(cat "$CREDENTIALS_DIRECTORY/bwPassword")"

          rustic --repo ${config.restic.repo} backup "$OUT/passwords.7z" --tag passwords --tag bitwarden --label $"Passwords (Bitwarden)" --group-by host,tags --skip-identical-parent

          rm -rf "$OUT"
        '';

        onFailure = lib.mkIf config.restic.notifyOnFail [ "restic-bitwarden-failed.service" ];
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

      systemd.services."restic-bitwarden-failed" = lib.mkIf config.restic.notifyOnFail {
        enable = true;
        serviceConfig = {
          Type = "oneshot";
          User = config.my.system.user.name;
        };

        # Required for notify-send
        environment.DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/${builtins.toString config.my.system.user.uid}/bus";

        script = ''
          ${pkgs.libnotify}/bin/notify-send --urgency=critical \
            "Restic bitwarden backup failed" \
            "$(journalctl -u restic-bitwarden-failed -n 5 -o cat)"
        '';
      };
    };
}
