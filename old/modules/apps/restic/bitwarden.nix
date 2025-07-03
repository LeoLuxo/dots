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
          export BW_CLIENTID=$(cat ${cfg.bwClientIDFile})
          export BW_CLIENTSECRET=$(cat ${cfg.bwClientSecretFile})
          OUT=$(mktemp --directory)

          # Cleanexit makes it so the login and unlock commands don't error out if bitwarden is already logged-in or unlocked
          bwclean='bw --nointeraction --cleanexit'

          $bwclean login --apikey
          export BW_SESSION=$($bwclean unlock --passwordfile ${cfg.bwPasswordFile} --raw)

          $bwclean export --output "$OUT/passwords.zip" --format zip
          $bwclean export --output "$OUT/passwords.csv" --format csv
          $bwclean export --output "$OUT/passwords.json" --format json
          $bwclean export --output "$OUT/passwords_encrypted.json" --format encrypted_json

          $bwclean lock
          # Don't log out because otherwise I keep getting emails about a new login on every back up -.-
          # $bwclean logout
          unset BW_SESSION
          unset BW_CLIENTID
          unset BW_CLIENTSECRET

          7z a "$OUT/passwords.7z" "$OUT/*" -p"$(cat ${cfg.bwPasswordFile})"

          rustic --password-file ${config.restic.passwordFile} --repo ${config.restic.repo} backup "$OUT/passwords.7z" --tag passwords --tag bitwarden --label $"Passwords (Bitwarden)" --group-by host,tags --skip-identical-parent

          rm -rf "$OUT"
          # rm -rf "/root/.config/Bitwarden CLI"
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
