{
  config,
  hostname,
  lib2,
  hosts,
  user,
  ...
}:

{
  services.syncthing =
    let
      syncthingFolder = "/home/${user}/.config/syncthing";
    in
    {
      enable = true;

      # By default if syncthing.user is not set, a user named "syncthing" will be created whose home directory is dataDir, and it will run under a group "syncthing".
      inherit user;
      group = "users";

      # Together, the key and cert define the device id
      key = config.age.secrets."syncthing/${hostname}/key.pem".path;
      cert = config.age.secrets."syncthing/${hostname}/cert.pem".path;

      # The path where default synchronised directories will be put.
      dataDir = syncthingFolder;
      # The path where the settings and keys (if not set expicitly) will be checked for.
      configDir = syncthingFolder;

      # Overrides any devices/folders added or deleted through the WebUI
      overrideDevices = true;
      overrideFolders = true;

      # Open firewall ports
      openDefaultPorts = true;

      settings = {
        # Automatically get all device ids from hosts
        devices = lib2.filterGetAttr "syncthing" hosts;

        options = {
          # Anonymous data usage
          urAccepted = 3;
          urSeen = 3;

          # Relay servers
          relaysEnabled = true;
        };
      };
    };
}
