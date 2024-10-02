{
  config,
  ...
}:
let
  inherit (config.age) secrets;
in
{
  imports = [
    ../../../modules/host/syncthing-common.nix
  ];

  services.syncthing = {
    # user = "pancake";

    # The path where synchronised directories will exist.
    # The path where the settings and keys will exist.
    dataDir = "/var/lib/syncthing";
    configDir = "/var/lib/syncthing";

    # Together, the key and cert define the device id
    key = secrets.syncthing-pancake-key.path;
    cert = secrets.syncthing-pancake-cert.path;

    settings = {
      gui = {
        # Don't care that it's public in the nix store
        user = "qwe";
        password = "qwe";
      };

      # Don't care that device ids are public in the nix store
      devices = {
        "neon" = {
          id = builtins.readFile secrets.syncthing-neon-id.path;
        };
        "celestia" = {
          id = builtins.readFile secrets.syncthing-celestia-id.path;
        };
      };

      folders = {
        "Obsidian" = {
          id = "zzaui-egygo";
          path = "/stuff/obsidian";
          devices = [
            "neon"
            "celestia"
          ];
        };

        "Important Docs" = {
          id = "ythpr-clgdt";
          path = "/stuff/important_docs";
          devices = [
            "neon"
          ];
        };

        "Share" = {
          id = "oguzw-svsqp";
          path = "/stuff/share";
          devices = [
            "neon"
          ];
        };

        "Uni Courses" = {
          id = "ddre2-cukd9";
          path = "/stuff/uni_courses";
          devices = [
            "neon"
          ];
        };

        "Vault" = {
          id = "p2ror-eujtw";
          path = "/stuff/vault";
          devices = [
            "neon"
          ];
        };
      };
    };
  };

  system.activationScripts."syncthing-stignore".text = ''
    printf "**/workspace*.json\n" > /stuff/obsidian/.stignore
    printf "**/target/\n" > /stuff/uni_courses/.stignore
  '';

}
