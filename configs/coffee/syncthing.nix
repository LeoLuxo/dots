{
  profiles,
  pkgs,
  ...
}:

{
  imports = [
    profiles.apps.syncthing
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
      path = [
        pkgs.rsync
      ];

      serviceConfig.ExecStart = (
        pkgs.writeShellScript "incoming-media-sort" ''
          SRC=
          SRCS=(
            "/stuff/incoming/media/dcim"
            "/stuff/incoming/media/pictures"
            "/stuff/incoming/media/videos"
          )
          DST="/stuff/media/photos/unsorted"

          MEDIA_EXTS="jpg|jpeg|png|gif|bmp|tiff|webp|heic|heif|raw|cr2|nef|arw|mp4|mkv|avi|mov|wmv|flv|webm|m4v|mpg|mpeg|3gp|mts|m2ts"

          # Remove junk folders before processing
          find "''${SRCS[@]}" -type d \( -name ".thumbnails" -o -name ".Thumbnails" -o -name "Thumbs" -o -name "@eaDir" -o -name ".DS_Store" \) -exec rm -rf {} +

          find "''${SRCS[@]}" -type f | grep -iE "\.($MEDIA_EXTS)$" | while read -r file; do
              echo
              echo "Processing file: $file"

              year=$(date -r "$file" +%Y)
              month=$(date -r "$file" +%m)
              target="$DST/$year/$month"
              
              echo "Destination: $target"
              mkdir --parents "$target"
              rsync --archive --human-readable --progress --remove-source-files "$file" "$target/"
          done

          # Remove empty directories from sources (except if it's a syncthing folder)
          echo "Removing empty directories"
          find "''${SRCS[@]}" -type d -empty -not -name ".stfolder" -delete
        ''
      );
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
