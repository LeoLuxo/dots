{
  config,
  ...
}:
let
  secrets = config.age.secrets;
  # syncthingFolder = "/home/lili/.config/syncthing";
  syncthingFolder = "/var/lib/syncthing";
in
{
  imports = [
    ../../../modules/host/syncthing-common.nix
  ];

  services.syncthing = {
    # user = "lili";

    # The path where synchronised directories will exist.
    # The path where the settings and keys will exist.
    dataDir = syncthingFolder;
    configDir = syncthingFolder;

    # Together, the key and cert define the device id
    key = secrets."syncthing/pancake/key.pem".path;
    cert = secrets."syncthing/pancake/cert.pem".path;

    settings = {
      gui = {
        # Don't care that it's public in the nix store
        user = "qwe";
        password = "qwe";
      };

      # Don't care that the device ids end up in cleartext on the nix store
      devices = {
        "neon".id = "WKZDG5X-W2DJB2N-3A7CS2H-VQDKBN2-RFDLM6P-KGZN4D6-KI2SD3E-3ZMNQAT";
        "celestia".id = "FEEK44G-XI3OFWE-TTTSDUC-WCTTXRX-JYGVGKG-AJDLL5I-FWEEQR4-H6YQ7QX";
      };

      # Folders
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

  # Manually setup ignore patterns
  systemd.services.syncthing-init.postStart = ''
    printf "**/workspace*.json\n" > /stuff/obsidian/.stignore
    printf "**/target/\n" > /stuff/uni_courses/.stignore
  '';
}
