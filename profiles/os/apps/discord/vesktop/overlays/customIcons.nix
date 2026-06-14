(final: prev: {
  vesktop = prev.vesktop.overrideAttrs (
    finalAttrs: oldAttrs: {
      # Overwrite the desktop item so the app name is "Discord"
      desktopItems = (
        prev.makeDesktopItem {
          name = "vesktop";
          desktopName = "Discord";
          exec = "vesktop %U";
          icon = "vesktop";
          startupWMClass = "Discord";
          genericName = "Internet Messenger";
          keywords = [
            "discord"
            "vencord"
            "vesktop"
            "electron"
            "chat"
          ];
          categories = [
            "Network"
            "InstantMessaging"
            "Chat"
          ];
        }
      );

      # Add a prebuild action to overwrite the tray and app icons and the dancing anime gif
      preBuild =
        (oldAttrs.preBuild or "")
        + ''
          cp -f "${./../assets/discord.png}" build/Icon.png

          cp -f "${./../assets/discord.png}" static/icon.png
          cp -f "${./../assets/discord.ico}" static/icon.ico

          # Dancing anime gif
          cp -f "${./../assets/bongo-cat.gif}" static/shiggy.gif
        '';

      # Add a preinstall action to overwrite the desktop icon
      preInstall =
        (oldAttrs.preInstall or "")
        + ''
          rm build/icon_*x32.png
          cp "${./../assets/discord.png}" build/icon_512x512x32.png
        '';
    }
  );
})
