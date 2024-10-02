{
  config,
  getHostModule,
  ...
}:
{
  imports = [
    (getHostModule "syncthing-common.nix")
  ];

  services.syncthing = {
    # user = "pancake";

    # The path where synchronised directories will exist.
    # The path where the settings and keys will exist.
    dataDir = "/var/lib/syncthing";
    configDir = "/var/lib/syncthing";

    # Together, the key and cert define the device id
    key = config.age.secrets.syncthing-pancake-key.path;
    cert = config.age.secrets.syncthing-pancake-cert.path;

    settings = {
      gui = {
        # Don't care that it's public in the nix store
        user = "qwe";
        password = "qwe";
      };

      # Don't care that device ids are public in the nix store
      devices = {
        "neon" = {
          id = builtins.readFile config.age.secrets.syncthing-neon-id.path;
        };
        # "celestia" = {
        #   id = "DEVICE-ID-GOES-HERE";
        # };
      };

      folders = {
        "Obsidian" = {
          id = "zzaui-egygo";
          path = "/stuff/obsidian";
          devices = [
            "neon"
          ];
        };
      };

    };
  };
}
