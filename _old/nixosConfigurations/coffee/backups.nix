{
  config,
  hostname,
  nixosModules,
  ...
}:
{
  imports = [ nixosModules.apps.restic ];

  age.secrets =
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
  restic =
    let
      repoPassword = config.age.secrets."restic/${hostname}-pwd".path;
    in
    {
      enable = true;
      repo = "/stuff/restic/repo";
      passwordFile = repoPassword;
      notifyOnFail = true;

      periodicChecks = {
        enable = true;
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

        "emu" = {
          timer = "hourly";
          randomDelay = "15m";

          label = "Emu";
          path = "/stuff/games/emu";
          tags = [ "emu" ];
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
          passwordFile = repoPassword;

          forget = {
            enable = true;
            prune = true;

            keepWithinHourly = "3d";
            keepWithinDaily = "10d";
            keepWithinWeekly = "1m";
            keepWithinMonthly = "1y";
            keepYearly = "unlimited";
          };
        };

        remoteRepos."hetzner-storage-box" = {
          path = "restic/coffee";
          passwordFile = repoPassword;
          remoteAddressFile = config.age.secrets."restic/storage-box-addr".path;
          # Don't specify key and let ssh find the right key/identity to connect with
          strictHostKeyChecking = false; # TODO: make true by configuring known_hosts correctly

          forget = {
            enable = true;
            prune = true;

            keepWithinHourly = "3d";
            keepWithinDaily = "10d";
            keepWithinWeekly = "1m";
            keepWithinMonthly = "1y";
            keepYearly = "unlimited";
          };
        };

        forget = {
          enable = true;
          prune = true;

          keepWithin = "2h";
          keepWithinHourly = "1d";
          keepWithinDaily = "7d";
          keepWithinWeekly = "1m";
        };
      };
    };
}
