{
  config,
  hostname,
  ...
}:
{
  # Setup my auto backups
  restic = rec {
    enable = true;
    repo = "/stuff/restic/repo";
    passwordFile = config.age.secrets."restic/${hostname}-pwd".path;
    notifyOnFail = true;

    periodicChecks = {
      timer = "0/2:00"; # every two hours
      randomDelay = "2h";
      readData = "5G";
      cleanupCache = true;
    };

    backups = {
      "home" = {
        timer = "hourly";
        randomDelay = "15m";

        label = "Home";
        path = config.my.system.user.home;
        glob = [
          "!/home/*/downloads"
          "!/home/*/.steam"
          "!/home/*/.cache"
          "!/home/*/.local/share/Trash"
          "!/home/*/.local/share/Steam/steamapps"
        ];
        tags = [ "home" ];
      };

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

    backupPresets = {
      ludusavi = {
        enable = true;
        timer = "hourly";
        randomDelay = "45m";
      };

      # bitwarden = {
      #   enable = true;
      #   timer = "daily";
      #   randomDelay = "1h";
      #   bwClientIDFile = config.age.secrets."bitwarden/client-id".path;
      #   bwClientSecretFile = config.age.secrets."bitwarden/client-secret".path;
      #   bwPasswordFile = config.age.secrets."bitwarden/password".path;
      # };
    };

    replication = {
      enable = true;
      timer = "daily";
      randomDelay = "2h";

      localRepos."hdd" = {
        path = "/backup/restic/repo";
        inherit passwordFile;
      };

      remoteRepos."hetzner-storage-box" = {
        path = "restic/coffee";
        inherit passwordFile;
        remoteAddressFile = config.age.secrets."restic/storage-box-addr".path;
        privateKey = config.my.system.keys.keys.user.private;
      };

      forget = {
        enable = true;
        prune = true;

        keepWithin = "1d";
        keepWithinHourly = "3d";
        keepWithinDaily = "10d";
        keepWithinWeekly = "1m";
        keepWithinMonthly = "1y";
        keepYearly = "unlimited";
      };
    };
  };
}
