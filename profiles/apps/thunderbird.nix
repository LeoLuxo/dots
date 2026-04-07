{ pkgs, user, ... }:
{
  # Install thunderbird
  environment.systemPackages = with pkgs; [
    thunderbird
  ];

  # Setup syncing of the settings over syncting
  # Will not do anything unless a client specifically sets the `devices` field for the "Thunderbird" folder

  services.syncthing.settings.folders."Thunderbird" = {
    id = "thund-rbird";
    path = "/home/${user}/.thunderbird";
    ignorePatterns = [
      # Whitelist: Profile settings
      "!profiles.ini"

      # Whitelist: Account & identity settings
      "!prefs.js"
      "!handlers.json"
      "!mailViews.dat"
      "!virtualFolders.dat"
      "!folderTree.json"
      "!xulstore.json"
      "!pkcs11.txt"

      # Whitelist: Address books
      "!abook*.sqlite"

      # Whitelist: OpenPGP / encryption
      "!encrypted-openpgp-passphrase.txt"
      "!openpgp.sqlite"

      # Whitelist: Extensions & add-ons
      "!extensions.json"
      "!addons.json"
      "!extension-preferences.json"
      "!addonStartup.json.lz4"
      "!extensions/"
      "!extension-store/"
      "!extension-store-userscripts/"
      "!browser-extension-data/"

      # Whitelist: Calendar
      "!calendar-data/"

      # Whitelist: Search config
      "!search.json.mozlz4"

      # Whitelist: Security (passwords, certs)
      "!cert9.db"
      "!key4.db"
      "!logins.json"
      "!logins-backup.json"
      "!logins.db"

      # Ignore everything else by default
      "*"
    ];
  };

}
