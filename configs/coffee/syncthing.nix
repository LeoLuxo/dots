{
  profiles,
  pkgs,
  ...
}:

{
  imports = [
    profiles.apps.syncthing
    profiles.scripts.mediaSort
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
            "pancake"
            "luna"
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
          ignorePatterns = [
            "bachelor*/"
            "result"
            "target"
            ".direnv"
          ];
          inherit versioning;
        };

        # The thunderbird module already sets up everything else for us
        "Thunderbird" = {
          devices = [
            "strobery"
            "pancake"
          ];
        };

        # Bring in stuff from phone for backup
        "Incoming DCIM" = {
          id = "88xc3-tg0v3";
          path = "/stuff/incoming/media/dcim";
          devices = [
            "luna"
          ];
          type = "receiveonly";
        };

        "Incoming Pictures" = {
          id = "0nx82-l39nu";
          path = "/stuff/incoming/media/pictures";
          devices = [
            "luna"
          ];
          type = "receiveonly";
        };

        "Incoming Videos" = {
          id = "gnaop-121mq";
          path = "/stuff/incoming/media/videos";
          devices = [
            "luna"
          ];
          type = "receiveonly";
        };

        # "Incoming Signal Backups" = {
        #   id = "vs5o5-tw8yg";
        #   path = "/stuff/incoming/signal";
        #   devices = [
        #     "luna"
        #   ];
        #   type = "receiveonly";
        # };

        # "Incoming WhatsApp Backups" = {
        #   id = "3lrkm-4t7wl";
        #   path = "/stuff/incoming/whatsapp";
        #   devices = [
        #     "luna"
        #   ];
        #   type = "receiveonly";
        # };
      };
    };

  # Move incoming phone media to their respective folders regurlarly using a systemd script
  systemd.user = {
    services."incoming-media-sort" = {
      serviceConfig.ExecStart = "media-sort /stuff/incoming/media /stuff/media/photos/unsorted";
    };

    # Schedule it daily
    timers."incoming-media-sort" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        RandomizedDelaySec = "1h";
        Persistent = true;
        Unit = "incoming-media-sort.service";
      };
    };
  };

  # systemd.user.services."wallutils-timed" = modules.mkIf cfg.isTimed {
  #   unitConfig = {
  #     Description = "Wallutils timed wallpaper service";
  #     PartOf = [ "graphical-session.target" ];
  #     After = [ "graphical-session.target" ];
  #   };
  #   # The additional path is needed because wallutils looks at the programs currently in the path to decide how to set wallpapers
  #   path = [ "/run/current-system/sw" ];
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = (
  #       pkgs.writeShellScript "wallutils-timed" ''
  #         pushd "${builtins.dirOf finalImage}"
  #         ${wallutils}/bin/settimed --mode ${cfg.mode} "${finalImage}"
  #       ''
  #     );
  #   };
  #   restartIfChanged = true;
  #   restartTriggers = [
  #     cfg.mode
  #     finalImage
  #   ];
  #   wantedBy = [ "graphical-session.target" ];
  # };

  # services."restic-autobackup-${name}" = {
  #   path = [
  #     pkgs.rustic
  #   ];

  #   serviceConfig.ExecStart = makeScript backup;

  #   onFailure = mkIf cfg.notifyOnFail [ "restic-autobackup-${name}-failed.service" ];
  # };

  # # Timers for each of the local backups
  # timers."restic-autobackup-${name}" = {
  #   wantedBy = [ "timers.target" ];
  #   timerConfig = {
  #     OnCalendar = backup.timer;
  #     Persistent = true;
  #     Unit = "restic-autobackup-${name}.service";
  #     RandomizedDelaySec = mkIf (backup.randomDelay != null) backup.randomDelay;
  #   };
  # };
}
