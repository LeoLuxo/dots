{
  cfg,
  options,
  extraLib,
  constants,
  config,
  lib,
  ...
}:

let
  inherit (constants) userHome user hostName;
  inherit (extraLib) mkDesktopItem mkEmptyLines;
  inherit (lib) types strings modules;

  # TODO: Remove when I update nixpkgs
  concatMapAttrsStringSep =
    sep: f: attrs:
    strings.concatStringsSep sep (lib.attrValues (lib.mapAttrs f attrs));
in

{
  # Copy over the options of the nixos module
  options = options.services.syncthing // {
    # Overriding the attsOf of the folders options is enough to let us add an extra option, the module system will take care of merging all the options
    settings.folders = lib.options.mkOption {
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

  config = modules.mkIf cfg.enable {
    home-manager.users.${constants.user}.home.packages = [
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

    services.syncthing =
      let
        syncthingFolder = "${userHome}/.config/syncthing";
      in
      {
        enable = true;

        # By default if syncthing.user is not set, a user named "syncthing" will be created whose home directory is dataDir, and it will run under a group "syncthing".
        inherit user;
        group = "users";

        # Together, the key and cert define the device id
        key = config.age.secrets."syncthing/${hostName}/key.pem".path;
        cert = config.age.secrets."syncthing/${hostName}/cert.pem".path;

        # The path where default synchronised directories will be put.
        dataDir = syncthingFolder;
        # The path where the settings and keys will be checked for.
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
          # I would accept it but for some reason values 1 or 2 wouldn't work
          urAccepted = -1;

          # Relay servers
          relaysEnabled = true;
        };
      }
      # Override config with whatever was setup in the options
      // cfg;

    # Setup ignore patterns
    systemd.services.syncthing-init.postStart = concatMapAttrsStringSep "\n" (
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
    ) cfg.settings.folders;
  };
}
