{
  lib,

  config,
  ...
}:

let
  inherit (extraLib)
    mkSubmodule
    mkBoolDefaultTrue
    mkEnable
    importModules
    ;
  inherit (lib) options types modules;
in

{
  imports = [
    # Triple buffering fork thing
    ./triple-buffering.nix

    # Default gnome apps
    ./default-apps.nix

    # All the dconf settings
    ./settings.nix

    # Import extensions
    (importModules ./extensions)
  ];

  options.desktop.gnome = {
    enable = mkEnable;

    power = mkSubmodule {
      buttonAction = options.mkOption {
        type = types.enum [
          "power off"
          "suspend"
          "hibernate"
          "nothing"
        ];
        default = "power off";
      };

      confirmShutdown = mkBoolDefaultTrue;

      screenIdle = mkSubmodule {
        enable = mkBoolDefaultTrue;

        delay = options.mkOption {
          type = types.ints.unsigned;
          default = 300;
        };
      };

      suspendIdle = mkSubmodule {
        enable = mkEnable;

        delay = options.mkOption {
          type = types.ints.unsigned;
          default = 1800;
        };
      };
    };

    extensions = options.mkOption {
      type = types.listOf types.str;
      default = [
        # Base extensions that should be included by default
        "just-perfection"
        "removable-drive-menu"
        "appindicator"
        "bluetooth-quick-connect"
      ];
    };
  };

  config = modules.mkIf cfg.enable {
    # Enable and configure the X11 windowing system.
    services.xserver = {
      enable = true;

      # Enable the GNOME Desktop Environment.
      displayManager.gdm = {
        enable = true;
        # UNder wayland
        wayland = true;
      };
      desktopManager.gnome.enable = true;
    };

    desktop.defaultsApps = {
      backupTerminal = lib.mkDefault "kgx";
      terminal = lib.mkOverride 1050 "kgx";
    };
  };
}
