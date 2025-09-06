{
  config,
  lib,
  hostname,
  pkgs,
  lib2,
  hosts,
  ...
}:

let
  inherit (lib) types options strings;
in

{
  options = {
    # Overriding the attsOf of the folders options is enough to let us add an extra option, the module system will take care of merging all the options
    services.syncthing.settings.folders = options.mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              ignorePatterns = lib.mkOption {
                type = types.lines;
                default = "";
              };
            };
          }
        )
      );
    };
  };

  config = {
    services.syncthing = {
      enable = true;

      # Together, the key and cert define the device id
      key = config.age.secrets."syncthing/${hostname}/key.pem".path;
      cert = config.age.secrets."syncthing/${hostname}/cert.pem".path;

      # Overrides any devices/folders added or deleted through the WebUI
      overrideDevices = true;
      overrideFolders = true;

      settings = {
        # Automatically get all device ids from hosts
        devices = lib2.filterGetAttr "syncthing" hosts;

        options = {
          # Anonymous data usage
          # I would accept it but for some reason values 1 or 2 don't work
          urAccepted = -1;

          # Relay servers
          relaysEnabled = true;
        };
      };
    };

    # Setup ignore patterns
    systemd.user.services.syncthing-init.Service.ExecStartPost = strings.concatMapAttrsStringSep "\n" (
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

    home.packages = [
      (pkgs.mkDesktopItem {
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
  };
}
