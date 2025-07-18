{
  extraLib,
  config,
  lib,
  hostname,
  ...
}:

let
  inherit (extraLib) mkDesktopItem mkEmptyLines;
  inherit (lib) types options strings;

  # TODO: Remove when I update nixpkgs
  concatMapAttrsStringSep =
    sep: f: attrs:
    strings.concatStringsSep sep (lib.attrValues (lib.mapAttrs f attrs));
in

{
  imports = [
    (mkDesktopItem {
      name = "syncthing";
      exec = "firefox \"http://127.0.0.1:8384/\"";
      icon = "${./syncthing.png}";
      categories = [
        "Network"
        "FileTransfer"
        "P2P"
      ];
    })
  ];

  options = {
    # Overriding the attsOf of the folders options is enough to let us add an extra option, the module system will take care of merging all the options
    services.syncthing.settings.folders = options.mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              ignorePatterns = mkEmptyLines;
            };
          }
        )
      );
    };
  };

  config = {
    services.syncthing =
      let
        syncthingFolder = "${config.my.paths.home}/.config/syncthing";
      in
      {
        enable = true;

        # By default if syncthing.user is not set, a user named "syncthing" will be created whose home directory is dataDir, and it will run under a group "syncthing".
        user = config.my.user.name;
        group = "users";

        # Together, the key and cert define the device id
        key = config.my.secrets."syncthing/${hostname}/key.pem";
        cert = config.my.secrets."syncthing/${hostname}/cert.pem";

        # The path where default synchronised directories will be put.
        dataDir = syncthingFolder;
        # The path where the settings and keys (if not set expicitly) will be checked for.
        configDir = syncthingFolder;

        # Overrides any devices/folders added or deleted through the WebUI
        overrideDevices = true;
        overrideFolders = true;

        # Open firewall ports
        openDefaultPorts = true;

        # Whether to auto-launch Syncthing as a system service.
        # systemService = true;

        settings.options = {
          # Anonymous data usage
          # I would accept it but for some reason values 1 or 2 don't work
          urAccepted = -1;

          # Relay servers
          relaysEnabled = true;
        };
      };

    # Setup ignore patterns
    systemd.user.services.syncthing-init.postStart = concatMapAttrsStringSep "\n" (
      name: value:
      if (strings.stringLength value.ignorePatterns) > 0 then
        ''
          if [ -d ${value.path} ]; then
            cat >${value.path}/.stignore <<-EOF
            ${value.ignorePatterns}EOF
          fi
        ''
      else
        ""
    ) config.services.syncthing.settings.folders;
  };
}
