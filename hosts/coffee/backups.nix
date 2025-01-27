{ config, constants, ... }:
{
  # Setup my auto backups
  restic = {
    enable = true;
    repo = "/stuff/Restic/repo";
    passwordFile = config.age.secrets."restic/${constants.hostName}-pwd".path;

    backups = {
      "obsidian" = {
        timer = "*:0/15"; # every 15 minutes

        label = "Obsidian";
        path = "/stuff/Obsidian";
        displayPath = "Obsidian";
        tags = [ "obsidian" ];
      };

      "uni-courses" = {
        timer = "hourly";
        randomDelay = "15m";

        label = "University Courses";
        path = "/stuff/UniCourses";
        displayPath = "UniCourses";
        tags = [ "uni-courses" ];
      };

      "important-docs" = {
        timer = "hourly";
        randomDelay = "15m";

        label = "Important Documents";
        path = "/stuff/ImportantDocs";
        displayPath = "ImportantDocs";
        tags = [ "important-docs" ];
      };

      "minecraft-instances" = {
        timer = "hourly";
        randomDelay = "15m";

        label = "Minecraft Instances";
        path = "/stuff/Games/Minecraft/instances";
        displayPath = "instances";
        tags = [ "minecraft-instances" ];
      };
    };

    gameSavesBackup = {
      enable = true;
      timer = "hourly";
      randomDelay = "60m";
    };
  };
}
