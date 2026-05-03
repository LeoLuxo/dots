{
  config,
  hostname,
  profiles,
  user,
  ...
}:
{
  imports = [
    profiles.apps.restic
    profiles.scripts.bitwardenBackup
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
    in
    {
      enable = true;
      repo = "/stuff/restic/repo";
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
          glob = [
            "!/home/*/downloads"
            "!/home/*/.steam"
            "!/home/*/.cache"
            "!/home/*/.local/share/Trash"
            "!/home/*/.local/share/Steam/steamapps"
            "!**/target"
            "!**/.direnv"
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

          glob = [
            "!**/target"
            "!**/.direnv"
          ];

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

          glob = [
            "!**/target"
            "!**/.direnv"
          ];

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

          timer = "hourly";
          randomDelay = "15m";
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

          timer = "hourly";
          randomDelay = "15m";

        };

        "voice" = {
          path = "/stuff/voice";

          label = "Voice";
          tags = [ "voice" ];

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
