{
  pkgs,
  user,
  directories,
  ...
}:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # Discord fork that fixes streaming issues on linux
      vesktop
      # (pkgs.callPackage ./package.nix { })
    ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      vesktop = prev.vesktop.overrideAttrs (
        finalAttrs: oldAttrs: {
          src = prev.fetchFromGitHub {
            owner = "PolisanTheEasyNick";
            repo = "Vesktop";
            rev = "3a84dbc0d28a8152284d82004b1315e7fe03778a";
            hash = "sha256-i+i0oOLST72cMWwtSHJnVDaWojMA3g7TXGvBBewGBcE=";
          };

          pnpmDeps = prev.pnpm_9.fetchDeps {
            inherit (finalAttrs)
              pname
              version
              src
              patches
              ;
            hash = "sha256-Y55CeMKXZALes7X8uwsnFI6QVExHU8AbvU/gxCvTLHs=";
          };

          # patches = [
          #   (prev.fetchpatch {
          #     url = "https://patch-diff.githubusercontent.com/raw/Vencord/Vesktop/pull/609.patch";
          #     hash = "sha256-UaAYbBmMN3/kYVUwNV0/tH7aNZk32JnaUwjsAaZqXwk=";
          #   })
          # ];

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
              cp -f "${directories.images.discord-logo-white}" build/Icon.png

              cp -f "${directories.images.discord-logo-white}" static/icon.png
              cp -f "${directories.icons.discord}" static/icon.ico

              cp -f "${directories.images.bongo-cat}" static/shiggy.gif
            '';

          # Add a preinstall action to overwrite the app icons and the dancing anime gif
          preInstall = ''
            rm build/icon_*x32.png
            cp "${directories.images.discord-logo-white}" build/icon_512x512x32.png
          '';
        }
      );
    })
  ];
}
