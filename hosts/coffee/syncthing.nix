{
  config,
  directories,
  constants,
  ...
}:

let
  inherit (constants) user userHome;
in

let
  syncthingFolder = "${userHome}/.config/syncthing";
in
{
  imports = with directories.modules; [
    syncthing
  ];

  services.syncthing = {
    inherit user;
    group = "users";

    # The path where synchronised directories will exist.
    # The path where the settings and keys will exist.
    dataDir = syncthingFolder;
    configDir = syncthingFolder;

    # Together, the key and cert define the device id
    key = config.age.secrets."syncthing/coffee/key.pem".path;
    cert = config.age.secrets."syncthing/coffee/cert.pem".path;

    settings = {
      gui = {
        # Don't care that it's public in the nix store
        user = "qwe";
        password = "qwe";
      };

      # Don't care that the device ids end up in cleartext on the nix store
      devices = {
        "strobery".id = "BH4QRX3-AXCRBBK-32KWW2A-33XYEMB-CKDONYH-4KLE4QA-NXE5LIX-QB4Q5AN";
        "pancake".id = "DS5FS25-BYJYFF2-TKBNJ4S-6RHZTEK-F4QS4EM-BNOPAPU-ULRHUA7-ORVTNA7";
        "celestia".id = "FEEK44G-XI3OFWE-TTTSDUC-WCTTXRX-JYGVGKG-AJDLL5I-FWEEQR4-H6YQ7QX";
      };

      # Folders
      folders = {
        "Obsidian" = {
          id = "zzaui-egygo";
          path = "/stuff/obsidian";
          devices = [
            "strobery"
            "pancake"
            "celestia"
          ];
        };

        "Important Docs" = {
          id = "ythpr-clgdt";
          path = "/stuff/important_docs";
          devices = [
            "strobery"
            "pancake"
          ];
        };

        "Share" = {
          id = "oguzw-svsqp";
          path = "/stuff/share";
          devices = [
            "strobery"
            "pancake"
          ];
        };

        "Uni Courses" = {
          id = "ddre2-cukd9";
          path = "/stuff/uni_courses";
          devices = [
            "strobery"
            "pancake"
          ];
        };

        "Vault" = {
          id = "p2ror-eujtw";
          path = "/stuff/vault";
          devices = [
            "strobery"
            "pancake"
          ];
        };
      };
    };
  };

  # Manually setup ignore patterns
  systemd.services.syncthing-init.postStart = ''
    mkdir --parents /stuff/uni_courses
    mkdir --parents /stuff/obsidian

    cat >/stuff/obsidian/.stignore <<-EOF
      **/workspace*.json
      .obsidian/vault-stats.json
    EOF

    cat >/stuff/uni_courses/.stignore <<-EOF
      **/target/
      Bachelor*/
    EOF
  '';
}
