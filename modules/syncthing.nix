{
  pkgs,
  directories,
  user,
  ...
}:
{
  # By default if syncthing.user is not set, a user named "syncthing" will be created whose home directory is dataDir, and it will run under a group "syncthing".
  services.syncthing.group = "users";

  services.syncthing = {
    enable = true;

    # Overrides any devices/folders added or deleted through the WebUI
    overrideDevices = true;
    overrideFolders = true;

    # Open firewall ports
    openDefaultPorts = true;

    # Whether to auto-launch Syncthing as a system service.
    # systemService = true;

    settings.options = {
      # Anonymous data usage
      urAccepted = -1;

      # Relay servers
      relaysEnabled = true;
    };
  };

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      syncthing-desktop-icon
    ];
  };

  nixpkgs.overlays = [
    (
      final: prev:
      let
        inherit (prev) stdenv lib makeDesktopItem;
      in
      {
        syncthing-desktop-icon = stdenv.mkDerivation (finalAttrs: {
          pname = "syncthing-desktop-icon";
          version = "0.0.0";

          dontUnpack = true;

          installPhase = lib.optionalString stdenv.hostPlatform.isLinux ''
            mkdir -p $out

            install -Dm0644 "${directories.images.syncthing}" $out/share/icons/hicolor/2048x2048/apps/syncthing.png
          '';

          desktopItems = lib.optional stdenv.hostPlatform.isLinux (makeDesktopItem {
            name = "syncthing";
            desktopName = "Syncthing";
            exec = "firefox \"http://127.0.0.1:8384/\"";
            icon = "syncthing";
            keywords = [
              "syncthing"
            ];
            categories = [
              "Network"
              "FileTransfer"
              "P2P"
            ];
          });
        });
      }
    )
  ];

}
