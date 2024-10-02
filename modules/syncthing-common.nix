{ ... }:
{
  # Make sure syncthing's user is in the group syncthing, might not be needed
  users.users."syncthing".extraGroups = [
    "syncthing"
  ];

  services.syncthing = {
    enable = true;

    # By default, a user named syncthing will be created whose home directory is dataDir.
    # user = "syncthing";

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

  # Open ports in the firewall?
  # networking.firewall.allowedTCPPorts = [
  #   8384
  #   22000
  # ];
  # networking.firewall.allowedUDPPorts = [
  #   22000
  #   21027
  # ];
}
