{
  config,
  pkgs,
  user,
  ...
}:

# assert config.restic.enable "bitwarden-backup cannot be used without restic!";
{
  age.secrets =
    let
      userPerms = {
        owner = user;
        group = "users";
        mode = "400"; # read-only for owner
      };
    in
    {
      "bitwarden/client-id" = userPerms;
      "bitwarden/client-secret" = userPerms;
    };

  home-manager.users.${user} = {
    home.packages = [
      (pkgs.writeScriptWithDeps {
        name = "bitwarden-backup";

        # --cleanexit makes it so the login and unlock commands don't error out if bitwarden is already logged-in or unlocked
        text = ''
          #!/usr/bin/env bash

          set -e

          OUT=$(mktemp --directory)

          cleanup () {
              ARG=$?
              
              rm -rf "$OUT"
              
              bw --nointeraction --cleanexit lock
              bw --nointeraction --cleanexit logout
              
              exit $ARG
          } 
          trap cleanup EXIT

          echo "Enter vault password: "
          read -s password
          export VAULT_PASSWORD=$password

          export BW_CLIENTID=$(cat ${config.age.secrets."bitwarden/client-id".path})
          export BW_CLIENTSECRET=$(cat ${config.age.secrets."bitwarden/client-secret".path})
          bw --nointeraction --cleanexit login --apikey
          unset BW_CLIENTID
          unset BW_CLIENTSECRET

          export BW_SESSION=$(bw --nointeraction --cleanexit unlock --passwordenv "VAULT_PASSWORD" --raw)

          bw --nointeraction export --output "$OUT/passwords.zip" --format zip
          bw --nointeraction export --output "$OUT/passwords.csv" --format csv
          bw --nointeraction export --output "$OUT/passwords.json" --format json

          unset BW_SESSION

          7z a "$OUT/passwords.7z" "$OUT/*" -p"$VAULT_PASSWORD"
          unset VAULT_PASSWORD

          rustic --repo ${config.restic.repo} backup "$OUT/passwords.7z" --tag passwords --tag bitwarden --label $"Passwords (Bitwarden)" --group-by host,tags --skip-identical-parent

          cleanup
        '';

        deps = with pkgs; [
          bitwarden-cli
          p7zip
          rustic
        ];
      })
    ];
  };
}
