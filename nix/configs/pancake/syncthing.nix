{
  profiles,
  ...
}:

{
  imports = [
    profiles.os.apps.syncthing
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
            "coffee"
          ];
          ignorePatterns = [
            "**/workspace*.json"
            ".obsidian/vault-stats.json"
          ];
          inherit versioning;
        };

        "Important Docs" = {
          id = "ythpr-clgdt";
          path = "/stuff/importantDocs";
          devices = [
            "strobery"
            "coffee"
            "luna"
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
          ignorePatterns = [
            "bachelor*/"
            "result"
            "target"
            ".direnv"
          ];
          inherit versioning;
        };

        "Photos" = {
          id = "dfhge-dfhtf";
          path = "/stuff/media/photos";
          devices = [
            "strobery"
            "coffee"
          ];
          ignorePatterns = [
            "unsorted/"
          ];
          inherit versioning;
        };

        # The thunderbird module already sets up everything else for us
        # "Thunderbird" = {
        #   devices = [
        #     "strobery"
        #     "coffee"
        #   ];
        # };
      };
    };

}
