{ directories, ... }:
{

  # Overlay to override app icons
  nixpkgs.overlays = [
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
              cp -f "${directories.images.discord-logo-white}" build/Icon.png

              cp -f "${directories.images.discord-logo-white}" static/icon.png
              cp -f "${directories.icons.discord}" static/icon.ico

              # Dancing anime gif
              cp -f "${directories.images.bongo-cat}" static/shiggy.gif
            '';

          # Add a preinstall action to overwrite the desktop icon
          preInstall =
            (oldAttrs.preInstall or "")
            + ''
              rm build/icon_*x32.png
              cp "${directories.images.discord-logo-white}" build/icon_512x512x32.png
            '';
        }
      );
    })
  ];
}
