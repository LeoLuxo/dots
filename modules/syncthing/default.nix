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
      (callPackage ./desktop.nix { inherit directories; })
    ];
  };

}