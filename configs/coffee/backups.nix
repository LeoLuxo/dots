{
  config,
  hostname,
  profiles,
  user,
  ...
}:
{
  imports = [
    profiles.os.apps.restic
    profiles.os.scripts.bitwardenBackup
  ];

  age.secrets =
    let
      userPerms = {
        owner = user;
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
      passwordFile = config.age.secrets."restic/${hostname}-pwd".path;

      devGlob = [
        "!**/target"
        "!**/.direnv"
        "!**/bin"
        "!**/obj"
      ];
    in
    {
      enable = true;
      repo = "/restic/repo";
      inherit passwordFile;
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
          path = "/home/${user}";
          glob = devGlob ++ [
            "!/home/*/downloads"
            "!/home/*/.steam"
            "!/home/*/.cache"
            "!/home/*/.local/share/Trash"
            "!/home/*/.local/share/Steam"
          ];
          tags = [ "home" ];
        };

        "obsidian" = {
          path = "/stuff/obsidian";

          label = "Obsidian";
          tags = [ "obsidian" ];

          timer = "*:0/15"; # every 15 minutes
        };

        "uni-courses" = {
          path = "/stuff/uniCourses";

          label = "University Courses";
          tags = [ "uni-courses" ];

          glob = devGlob;

          timer = "hourly";
          randomDelay = "15m";
        };

        "important-docs" = {
          path = "/stuff/importantDocs";

          label = "Important Documents";
          tags = [ "important-docs" ];

          timer = "hourly";
          randomDelay = "15m";
        };

        "share" = {
          path = "/stuff/share";

          label = "Share";
          tags = [ "share" ];

          glob = devGlob;

          timer = "hourly";
          randomDelay = "15m";
        };

        "minecraft-instances" = {
          path = "/stuff/games/minecraft/instances";

          label = "Minecraft Instances";
          tags = [ "minecraft-instances" ];

          timer = "hourly";
          randomDelay = "15m";
        };

        "media" = {
          path = "/stuff/media";

          label = "Media";
          tags = [
            "media"
            "music"
          ];

          iglob = [
            "!*lossy*"
          ];

          timer = "daily";
          randomDelay = "1h";
        };

        "emu" = {
          path = "/stuff/games/emu";

          label = "Emu";
          tags = [ "emu" ];

          timer = "hourly";
          randomDelay = "15m";
        };

        "band" = {
          path = "/stuff/band";

          label = "Band";
          tags = [ "band" ];

          timer = "daily";
          randomDelay = "1h";
        };

        "voice" = {
          path = "/stuff/voice";

          label = "Voice";
          tags = [ "voice" ];

          timer = "daily";
          randomDelay = "1h";
        };

        "projects" = {
          path = "/stuff/projects";

          label = "Projects";
          tags = [ "projects" ];

          glob = devGlob;

          timer = "hourly";
          randomDelay = "15m";
        };
      };

      backupPresets = {
        ludusavi = {
          enable = true;
          timer = "hourly";
          randomDelay = "45m";
        };
      };

      replication = {
        enable = true;
        timer = "daily";
        randomDelay = "2h";

        localRepos."hdd" = {
          path = "/backup/restic/repo";
          inherit passwordFile;

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
          inherit passwordFile;
          remoteAddressFile = config.age.secrets."restic/storage-box-addr".path;
          # Don't specify key and let ssh find the right key/identity to connect with
          strictHostKeyChecking = false; # TODO: make true by configuring known_hosts correctly

          forget = {
            enable = true;
            prune = true;

            keepWithinHourly = "3d";
            keepWithinDaily = "1m";
            keepWithinWeekly = "6m";
            keepWithinMonthly = "2y";
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
