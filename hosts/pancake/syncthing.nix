{
  config,
  nixosModules,
  constants,
  ...
}:

let
  inherit (constants) user userHome;
in

let
  syncthingFolder = "${userHome}/.config/syncthing";

  versioning = {
    type = "simple";
    params = {
      cleanoutDays = "100";
      keep = "5";
    };
    cleanupIntervalS = 3600;
    fsPath = "";
    fsType = "basic";
  };
in
{
  imports = with nixosModules; [
    apps.syncthing
  ];

  services.syncthing = {
    inherit user;
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
        "coffee".id = "WKZDG5X-W2DJB2N-3A7CS2H-VQDKBN2-RFDLM6P-KGZN4D6-KI2SD3E-3ZMNQAT";
        "celestia".id = "FEEK44G-XI3OFWE-TTTSDUC-WCTTXRX-JYGVGKG-AJDLL5I-FWEEQR4-H6YQ7QX";
      };

      # Folders
      folders = {
        "Obsidian" = {
          id = "zzaui-egygo";
          path = "/stuff/Obsidian";
          devices = [
            "strobery"
            "coffee"
            "celestia"
          ];
          inherit versioning;
        };

        "Important Docs" = {
          id = "ythpr-clgdt";
          path = "/stuff/ImportantDocs";
          devices = [
            "strobery"
            "coffee"
          ];
          inherit versioning;
        };

        "Share" = {
          id = "oguzw-svsqp";
          path = "/stuff/Share";
          devices = [
            "strobery"
            "coffee"
          ];
          inherit versioning;
        };

        "Uni Courses" = {
          id = "ddre2-cukd9";
          path = "/stuff/UniCourses";
          devices = [
            "strobery"
            "coffee"
          ];
          inherit versioning;
        };

        "Vault" = {
          id = "p2ror-eujtw";
          path = "/stuff/Vault";
          devices = [
            "strobery"
            "coffee"
          ];
          inherit versioning;
        };
      };
    };
  };

  # Manually setup ignore patterns
  systemd.services.syncthing-init.postStart = ''
    mkdir --parents /stuff/UniCourses
    mkdir --parents /stuff/Obsidian

    cat >/stuff/Obsidian/.stignore <<-EOF
      **/workspace*.json
      .obsidian/vault-stats.json
    EOF

    cat >/stuff/UniCourses/.stignore <<-EOF
      **/target/
      Bachelor*/
    EOF
  '';
}
