{
  config,
  hostname,
  constants,
  ...
}:
{
  # Setup my auto backups
  restic = {
    enable = true;
    repo = "/stuff/restic/repo";
    passwordFile = config.age.secrets."restic/${hostname}-pwd".path;

    backups = {
      "obsidian" = {
        timer = "*:0/15"; # every 15 minutes

        label = "Obsidian";
        path = "/stuff/obsidian";
        tags = [ "obsidian" ];
      };

      "uni-courses" = {
        timer = "hourly";
        randomDelay = "15m";

        label = "University Courses";
        path = "/stuff/uniCourses";
        tags = [ "uni-courses" ];
      };

      "important-docs" = {
        timer = "hourly";
        randomDelay = "15m";

        label = "Important Documents";
        path = "/stuff/importantDocs";
        tags = [ "important-docs" ];
      };

      "share" = {
        timer = "hourly";
        randomDelay = "15m";

        label = "Share";
        path = "/stuff/share";
        tags = [ "share" ];
      };

      "minecraft-instances" = {
        timer = "hourly";
        randomDelay = "15m";

        label = "Minecraft Instances";
        path = "/stuff/games/minecraft/instances";
        tags = [ "minecraft-instances" ];
      };

      "music" = {
        timer = "hourly";
        randomDelay = "15m";

        label = "Music";
        path = "/stuff/media/music";
        tags = [ "music" ];
      };

      "roms" = {
        timer = "hourly";
        randomDelay = "15m";

        label = "Roms";
        path = "/stuff/games/roms";
        tags = [ "roms" ];
      };
    };

    gameSavesBackup = {
      enable = true;
      timer = "hourly";
      randomDelay = "60m";
    };
  };
}
