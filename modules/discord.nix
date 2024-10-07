{
  pkgs,
  user,
  imageSet,
  ...
}:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # Discord fork that fixes streaming issues on linux
      vesktop
    ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      vesktop = prev.vesktop.overrideAttrs (oldAttrs: {

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
          oldAttrs.preBuild
          + ''
            cp -f "${imageSet.discord-white}" build/Icon.png

            cp -f "${imageSet.discord-white}" static/icon.png
            cp -f "${imageSet.discord-icon}" static/icon.ico

            cp -f "${imageSet.bongo-cat}" static/shiggy.gif
          '';

        # Add a preinstall action to overwrite the app icons and the dancing anime gif
        preInstall = ''
          rm build/icon_*x32.png
          cp "${imageSet.discord-white}" build/icon_512x512x32.png
        '';
      });
    })
  ];
}
