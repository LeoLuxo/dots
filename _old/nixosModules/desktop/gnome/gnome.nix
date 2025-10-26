{
  lib,
  lib2,
  nixosModules,
  config,
  pkgs,
  user,
  ...
}:

let
  inherit (lib) options types modules;
  inherit (lib2) mkSubmodule;
in

{
  options.desktop.gnome = {
    enable = options.mkEnableOption "enable the GNOME Desktop Environment";

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

      confirmShutdown = lib.mkOption {
        type = types.bool;
        default = true;
      };

      screenIdle = mkSubmodule {
        enable = lib.mkOption {
          type = types.bool;
          default = true;
        };

        delay = options.mkOption {
          type = types.ints.unsigned;
          default = 300;
        };
      };

      suspendIdle = mkSubmodule {
        enable = lib.mkOption {
          type = types.bool;
          default = false;
        };

        delay = options.mkOption {
          type = types.ints.unsigned;
          default = 1800;
        };
      };
    };

    display = mkSubmodule {
      textScalingPercent = options.mkOption {
        type = types.ints.unsigned;
        default = 100;
      };
    };
  };

  imports = with nixosModules; [
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

      # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
      # (even with autologin disabled I need this otherwise nixos-rebuild crashes gnome??)
      systemd.services."getty@tty1".enable = false;
      systemd.services."autovt@tty1".enable = false;

      # Enable the GNOME Desktop Environment.
      services.xserver = {
        displayManager.gdm = {
          enable = true;
          wayland = true;
        };

        desktopManager.gnome = {
          enable = true;

          extraGSettingsOverridePackages = [ pkgs.mutter ];
          extraGSettingsOverrides = ''
            [org.gnome.mutter]
            experimental-features=['variable-refresh-rate', 'scale-monitor-framebuffer']
          '';
        };
      };

      # Kinda random fix for the weird stuff with my second monitor? Is supposed to leave some time for mutter to recognize all screens before initializing gnome
      systemd.services.display-manager.preStart = ''
        sleep 2
      '';

      # Enable the gnome keyring
      services.gnome.gnome-keyring.enable = true;

      environment.variables = {
        APP_TERMINAL = lib.mkOverride 1050 "kgx"; # Even lower priority than mkDefault (smaller = higher priority)
        APP_TERMINAL_BACKUP = lib.mkDefault "kgx"; # Priority 1000
      };

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
