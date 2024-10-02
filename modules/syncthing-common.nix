{ pkgs, ... }:
{
  # By default if syncthing.user is not set, a user named syncthing will be created whose home directory is dataDir.
  # Make sure syncthing's user is in the group syncthing, might not be needed
  users.users."syncthing".extraGroups = [
    "syncthing"
  ];

  services.syncthing = {
    enable = true;

    # Overrides any devices/folders added or deleted through the WebUI
    overrideDevices = true;
    overrideFolders = true;

    # Whether to auto-launch Syncthing as a system service.
    # systemService = true;

    settings.options = {
      # Anonymous data usage
      urAccepted = 1;

      # Relay servers
      relaysEnabled = true;
    };
  };

  # Tray app
  environment.systemPackages = with pkgs; [
    syncthingtray-minimal
  ];

  # Open ports in the firewall? Apparently not needed
  # networking.firewall.allowedTCPPorts = [
  #   8384
  #   22000
  # ];
  # networking.firewall.allowedUDPPorts = [
  #   22000
  #   21027
  # ];
}
