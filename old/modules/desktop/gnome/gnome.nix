{
  lib,
  nixosModulesOld,
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

  imports = with nixosModulesOld; [
    # Triple buffering fork thing
    # ./triple-buffering.nix

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
      # HEIC support
      environment.systemPackages = [
        pkgs.libheif
        pkgs.libheif.out
      ];
      environment.pathsToLink = [ "share/thumbnailers" ];

      # Enable and configure the X11 windowing system.
      services.xserver = {
        enable = true;

        # Enable the GNOME Desktop Environment.
        displayManager.gdm = {
          enable = true;
          wayland = true;
        };

        desktopManager.gnome = {
          enable = true;

          extraGSettingsOverridePackages = [ pkgs.mutter ];
          extraGSettingsOverrides = ''
            [org.gnome.mutter]
            experimental-features=['variable-refresh-rate']
          '';
        };
      };

      defaults.apps.backupTerminal = lib.mkDefault "kgx";
      defaults.apps.terminal = lib.mkOverride 1050 "kgx";

      # Fixes "Your GStreamer installation is missing a plug-in." when trying to view audio/video properties
      environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 =
        lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0"
          [
            pkgs.gst_all_1.gst-plugins-good
            pkgs.gst_all_1.gst-plugins-bad
            pkgs.gst_all_1.gst-plugins-ugly
            pkgs.gst_all_1.gst-plugins-base
          ];
    };
}
