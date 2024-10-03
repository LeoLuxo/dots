{
  lib,
  config,
  ...
}:
with builtins;
with lib;
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

      devices = {
        "neon".id = strings.trim (traceVal (readFile secrets."syncthing/neon/id".path));
        "celestia".id = strings.trim (traceVal (readFile secrets."syncthing/celestia/id".path));
        # "neon".id = "WKZDG5X-W2DJB2N-3A7CS2H-VQDKBN2-RFDLM6P-KGZN4D6-KI2SD3E-3ZMNQAT";
        # "celestia".id = "FEEK44G-XI3OFWE-TTTSDUC-WCTTXRX-JYGVGKG-AJDLL5I-FWEEQR4-H6YQ7QX";
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

  # Manually setup ignore patterns
  systemd.services.syncthing-init.postStart = ''
    printf "**/workspace*.json\n" > /stuff/obsidian/.stignore
    printf "**/target/\n" > /stuff/uni_courses/.stignore
  '';

  # system.activationScripts = {
  #   "syncthing-stignore".text = ''
  #     printf "**/workspace*.json\n" > /stuff/obsidian/.stignore
  #     printf "**/target/\n" > /stuff/uni_courses/.stignore
  #   '';

  #   # Replace device ids at activation time in the config file, otherwise they might not be decrypted yet
  #   "syncthing-device-ids".text = ''
  #     nix-shell -p sudo coreutils --run sudo sed -i -e s/===PLACEHOLDER_ID_NEON===/$(cat ${
  #       secrets."syncthing/neon/id".path
  #     })/g ${syncthingFolder}/config.xml

  #     nix-shell -p sudo coreutils --run sudo sed -i -e s/===PLACEHOLDER_ID_CELESTIA===/$(cat ${
  #       secrets."syncthing/celestia/id".path
  #     })/g ${syncthingFolder}/config.xml
  #   '';
  # };

}
