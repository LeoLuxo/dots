{
  lib,
  nixosModules,
  extraLib,
  config,
  pkgs,
  ...
}:

let
  inherit (extraLib) mkSubmodule mkBoolDefaultTrue mkBoolDefaultFalse;
  inherit (lib) options types modules;
in

{
  options.desktop.gnome = {
    enable = mkBoolDefaultFalse;

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
        enable = mkBoolDefaultFalse;

        delay = options.mkOption {
          type = types.ints.unsigned;
          default = 1800;
        };
      };
    };
  };

  imports = with nixosModules; [
    # Triple buffering fork thing
    ./triple-buffering.nix

    # Default gnome apps
    ./default-apps.nix

    # All the dconf settings
    ./settings.nix

    # Base extensions that should be included by default
    desktop.gnome.extensions.just-perfection
    desktop.gnome.extensions.removable-drive-menu
    desktop.gnome.extensions.appindicator
    desktop.gnome.extensions.bluetooth-quick-connect
  ];

  config =
    let
      cfg = config.desktop.gnome;
    in
    modules.mkIf cfg.enable {
      # Enable and configure the X11 windowing system.
      services.xserver = {
        enable = true;

        # Enable the GNOME Desktop Environment.
        displayManager.gdm = {
          enable = true;
          # UNder wayland
          wayland = true;
        };
        desktopManager.gnome = {
          enable = true;

          # extraGSettingsOverridePackages = [ pkgs.gnome.mutter ];
          extraGSettingsOverrides = ''
            [org.gnome.mutter]
            experimental-features=['variable-refresh-rate', 'scale-monitor-framebuffer']
          '';
        };
      };

      defaults.apps.backupTerminal = lib.mkDefault "kgx";
      defaults.apps.terminal = lib.mkOverride 1050 "kgx";
    };
}
