{
  ...
}:

{
  apps.syncthing = {
    enable = true;
    settings =
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

        # Don't care that the device ids end up in cleartext on the nix store
        devices = {
          "strobery".id = "BH4QRX3-AXCRBBK-32KWW2A-33XYEMB-CKDONYH-4KLE4QA-NXE5LIX-QB4Q5AN";
          "coffee".id = "WKZDG5X-W2DJB2N-3A7CS2H-VQDKBN2-RFDLM6P-KGZN4D6-KI2SD3E-3ZMNQAT";
          "celestia".id = "2DPZ3IR-YH4YGS3-SGEZMRY-PMJNDZ4-3PBAE4D-V3IT5CA-4R4KVB5-MFH2WAL";
        };

        # Folders
        folders = {
          "Obsidian" = {
            id = "zzaui-egygo";
            path = "/stuff/obsidian";
            devices = [
              "strobery"
              "coffee"
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
              "coffee"
              "celestia"
            ];
            inherit versioning;
          };

          "Share" = {
            id = "oguzw-svsqp";
            path = "/stuff/share";
            devices = [
              "strobery"
              "coffee"
            ];
            inherit versioning;
          };

          "Uni Courses" = {
            id = "ddre2-cukd9";
            path = "/stuff/uniCourses";
            devices = [
              "strobery"
              "coffee"
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
              "coffee"
            ];
            inherit versioning;
          };
        };
      };
  };

}
