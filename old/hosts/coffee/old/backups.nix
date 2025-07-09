{
  config,
  hostname,
  ...
}:
{
  my.secretManagement.secrets =
    let
      userPerms = {
        owner = config.my.user.name;
        group = "users";
        mode = "400"; # read-only for owner
      };
    in
    {
      "restic/${hostname}-pwd" = userPerms;
      "restic/storage-box-addr" = userPerms;
    };

  # Setup my auto backups
  my.apps.restic =
    let
      repoPassword = config.my.secrets."restic/${hostname}-pwd";
    in
    {
      enable = true;
      repo = "/stuff/restic/repo";
      passwordFile = repoPassword;
      notifyOnFail = true;

      periodicChecks = {
        timer = "0/2:00"; # every two hours
        randomDelay = "2h";
        readData = "5G";
        cleanupCache = true;
      };

      backups = {
        "home" = {
          timer = "daily";
          randomDelay = "2h";

          label = "Home";
          path = "${config.my.paths.home}";
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
        #   bwClientIDFile = config.my.secrets."bitwarden/client-id";
        #   bwClientSecretFile = config.my.secrets."bitwarden/client-secret";
        #   bwPasswordFile = config.my.secrets."bitwarden/password";
        # };
      };

      replication = {
        enable = true;
        timer = "daily";
        randomDelay = "2h";

        localRepos."hdd" = {
          path = "/backup/restic/repo";
          passwordFile = repoPassword;
        };

        remoteRepos."hetzner-storage-box" = {
          path = "restic/coffee";
          passwordFile = repoPassword;
          remoteAddressFile = config.my.secrets."restic/storage-box-addr";
          # Don't specify key and let ssh find the right key/identity to connect with
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
