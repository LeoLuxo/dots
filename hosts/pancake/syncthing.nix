{
  config,
  directories,
  ...
}:

let
  syncthingFolder = "/home/lili/.config/syncthing";
in
{
  imports = with directories.modules; [
    syncthing
  ];

  services.syncthing = {
    user = "lili";
    group = "users";

    # The path where synchronised directories will exist.
    # The path where the settings and keys will exist.
    dataDir = syncthingFolder;
    configDir = syncthingFolder;

    # Together, the key and cert define the device id
    key = config.age.secrets."syncthing/pancake/key.pem".path;
    cert = config.age.secrets."syncthing/pancake/cert.pem".path;

    settings = {
      gui = {
        # Don't care that it's public in the nix store
        user = "qwe";
        password = "qwe";
      };

      # Don't care that the device ids end up in cleartext on the nix store
      devices = {
        "strobery".id = "BH4QRX3-AXCRBBK-32KWW2A-33XYEMB-CKDONYH-4KLE4QA-NXE5LIX-QB4Q5AN";
        "neon".id = "WKZDG5X-W2DJB2N-3A7CS2H-VQDKBN2-RFDLM6P-KGZN4D6-KI2SD3E-3ZMNQAT";
        "celestia".id = "FEEK44G-XI3OFWE-TTTSDUC-WCTTXRX-JYGVGKG-AJDLL5I-FWEEQR4-H6YQ7QX";
      };

      # Folders
      folders = {
        "Obsidian" = {
          id = "zzaui-egygo";
          path = "/stuff/obsidian";
          devices = [
            "strobery"
            "neon"
            "celestia"
          ];
        };

        "Important Docs" = {
          id = "ythpr-clgdt";
          path = "/stuff/important_docs";
          devices = [
            "strobery"
            "neon"
          ];
        };

        "Share" = {
          id = "oguzw-svsqp";
          path = "/stuff/share";
          devices = [
            "strobery"
            "neon"
          ];
        };

        "Uni Courses" = {
          id = "ddre2-cukd9";
          path = "/stuff/uni_courses";
          devices = [
            "strobery"
            "neon"
          ];
        };

        "Vault" = {
          id = "p2ror-eujtw";
          path = "/stuff/vault";
          devices = [
            "strobery"
            "neon"
          ];
        };
      };
    };
  };

  # Manually setup ignore patterns
  systemd.services.syncthing-init.postStart = ''
    printf "**/workspace*.json\n.obsidian/vault-stats.json\n" > /stuff/obsidian/.stignore
    printf "**/target/\n" > /stuff/uni_courses/.stignore
  '';
}
