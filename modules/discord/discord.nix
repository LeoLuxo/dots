{
  pkgs,
  user,
  iconSet,
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

        # Add a prebuild action to overwrite the tray icon
        preBuild =
          oldAttrs.preBuild
          + ''
            pushd build
            cp ${iconSet.discord-white} Icon.png
            popd
          '';

        # Add a preinstall action to overwrite the app icons
        preInstall = ''
          pushd build
          rm icon_*x32.png
          cp ${iconSet.discord-white} icon_512x512x32.png
          popd
        '';
      });
    })
  ];
}
