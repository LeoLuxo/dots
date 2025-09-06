{
  homeProfiles,
  ...
}:

{
  imports = [
    homeProfiles.apps.syncthing
  ];

  services.syncthing.settings =
    let
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
      gui = {
        # Don't care that it's public in the nix store
        user = "qwe";
        password = "qwe";
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
          ignorePatterns = ''
            **/workspace*.json
            .obsidian/vault-stats.json
          '';
          inherit versioning;
        };

        "Important Docs" = {
          id = "ythpr-clgdt";
          path = "/stuff/importantDocs";
          devices = [
            "strobery"
            "pancake"
            "celestia"
          ];
          inherit versioning;
        };

        "Share" = {
          id = "oguzw-svsqp";
          path = "/stuff/share";
          devices = [
            "strobery"
            "pancake"
          ];
          inherit versioning;
        };

        "Uni Courses" = {
          id = "ddre2-cukd9";
          path = "/stuff/uniCourses";
          devices = [
            "strobery"
            "pancake"
          ];
          ignorePatterns = ''
            bachelor*/
            **/target/
            **/.direnv/
          '';
          inherit versioning;
        };

        "Vault" = {
          id = "p2ror-eujtw";
          path = "/stuff/vault";
          devices = [
            "strobery"
            "pancake"
          ];
          inherit versioning;
        };

        "Incoming DCIM" = {
          id = "88xc3-tg0v3";
          path = "/stuff/incoming/dcim";
          devices = [
            "celestia"
          ];
          type = "receiveonly";
        };

        "Incoming Pictures" = {
          id = "0nx82-l39nu";
          path = "/stuff/incoming/pictures";
          devices = [
            "celestia"
          ];
          type = "receiveonly";
        };

        "Incoming Videos" = {
          id = "gnaop-121mq";
          path = "/stuff/incoming/videos";
          devices = [
            "celestia"
          ];
          type = "receiveonly";
        };

        "Incoming Signal Backups" = {
          id = "vs5o5-tw8yg";
          path = "/stuff/incoming/signal";
          devices = [
            "celestia"
          ];
          type = "receiveonly";
        };

        "Incoming WhatsApp Backups" = {
          id = "3lrkm-4t7wl";
          path = "/stuff/incoming/whatsapp";
          devices = [
            "celestia"
          ];
          type = "receiveonly";
        };
      };
    };
}
