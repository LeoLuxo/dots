{
  lib,
  lib2,
  nixosModules,
  config,
  pkgs,
  user,
  inputs,
  ...
}:

let
  inherit (lib) options types modules;
  inherit (lib2) mkSubmodule toPascalCase;
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

    blur = {
      enable = lib.mkOption {
        type = types.bool;
        default = true;
      };

      app-blur = mkSubmodule {
        enable = lib.mkOption {
          type = types.bool;
          default = false;
        };
      };

      hacks-level = options.mkOption {
        type = types.enum [
          "high performance"
          "default"
          "no artifact"
        ];
        default = "default";
      };
    };

    theme = {
      flavor = options.mkOption {
        type = types.enum [
          "latte"
          "frappe"
          "macchiato"
          "mocha"
        ];
        default = "frappe";
      };

      accent = options.mkOption {
        type = types.enum [
          "blue"
          "flamingo"
          "green"
          "lavender"
          "maroon"
          "mauve"
          "peach"
          "pink"
          "red"
          "rosewater"
          "sapphire"
          "sky"
          "teal"
          "yellow"
        ];
        default = "blue";
      };
    };

    cursor = {
      size = options.mkOption {
        type = types.ints.unsigned;
        default = 32;
      };

      flavor = options.mkOption {
        type = types.enum [
          "latte"
          "frappe"
          "macchiato"
          "mocha"
        ];
        default = config.desktop.gnome.theme.flavor;
      };

      accent = options.mkOption {
        type = types.enum [
          "dark"
          "light"

          "blue"
          "flamingo"
          "green"
          "lavender"
          "maroon"
          "mauve"
          "peach"
          "pink"
          "red"
          "rosewater"
          "sapphire"
          "sky"
          "teal"
          "yellow"
        ];
        default = "dark";
      };
    };
  };

  imports = with nixosModules; [
    # Triple buffering fork thing, broken atm
    # ./tripleBuffering.nix

    # Default gnome apps
    ./defaultApps.nix

    inputs.catppuccin.nixosModules.catppuccin

    # Base extensions that should be included by default
    desktop.gnome.extensions.just-perfection
    desktop.gnome.extensions.removable-drive-menu
    desktop.gnome.extensions.appindicator
    desktop.gnome.extensions.bluetooth-quick-connect

    # My extensions
    desktop.gnome.extensions.ddterm
    desktop.gnome.extensions.blur-my-shell
    desktop.gnome.extensions.clipboard-indicator
    desktop.gnome.extensions.gsconnect
    desktop.gnome.extensions.rounded-corners
    desktop.gnome.extensions.system-monitor
    desktop.gnome.extensions.media-controls
    desktop.gnome.extensions.burn-my-windows
    desktop.gnome.extensions.touchpad-gesture-customization
  ];

  config =
    let
      cfg = config.desktop.gnome;
    in
    modules.mkIf cfg.enable {
      programs.dconf.enable = true;

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
        sleep 4
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

      gnome.blur-my-shell = config.desktop.gnome.blur;

      environment.variables = {
        XCURSOR_SIZE = config.desktop.gnome.cursor.size;
      };

      # Disable catppuccin for the bootloader
      boot.plymouth.catppuccin.enable = false;

      catppuccin = {
        # Enable the theme for all compatible apps
        enable = true;

        # Choose flavor
        flavor = config.desktop.gnome.theme.flavor;
        accent = config.desktop.gnome.theme.accent;
      };

      home-manager.users.${user} =
        { lib, user, ... }:
        let
          inherit (lib.hm.gvariant) mkUint32;

          name = "catppuccin-${config.desktop.gnome.cursor.flavor}-${config.desktop.gnome.cursor.accent}-cursors";
          package =
            pkgs.catppuccin-cursors."${config.desktop.gnome.cursor.flavor}${toPascalCase config.desktop.gnome.cursor.accent}";
        in
        {
          imports = [
            inputs.catppuccin.homeManagerModules.catppuccin
          ];

          # Enable catppuccin for gtk
          gtk = {
            enable = true;
            catppuccin = {
              enable = true;
              flavor = config.desktop.gnome.theme.flavor;
              accent = config.desktop.gnome.theme.accent;
              size = "standard";
              tweaks = [ "normal" ];
            };
          };

          home.pointerCursor = {
            inherit name package;

            size = config.desktop.gnome.cursor.size;
            gtk.enable = true;
            x11.enable = true;
          };

          gtk.cursorTheme = {
            inherit name package;
          };

          # Add aliases
          home.shellAliases = {
            "find-shortcut" = "gsettings list-recursively | grep -i";
          };

          dconf.settings = {
            # Power settings
            "org/gnome/settings-daemon/plugins/power" = {
              power-button-action =
                {
                  "power off" = "interactive";
                  "suspend" = "suspend";
                  "hibernate" = "hibernate";
                  "nothing" = "nothing";
                }
                .${cfg.power.buttonAction};

              sleep-inactive-ac-type = if cfg.power.suspendIdle.enable then "suspend" else "nothing";
              sleep-inactive-ac-timeout = cfg.power.suspendIdle.delay;

              ambient-enabled = false; # Whether to adapt the screen brightness to the environment
            };

            "org/gnome/gnome-session" = {
              logout-prompt = cfg.power.confirmShutdown;
            };

            "org/gnome/desktop/session" = {
              idle-delay = mkUint32 (if cfg.power.screenIdle.enable then cfg.power.screenIdle.delay else 0);
            };

            "org/gnome/desktop/peripherals/mouse" = {
              speed = -0.2;
            };

            # System shortcuts
            "org/gnome/desktop/wm/keybindings" = {
              # The default is Alt-tab to switch "apps" instead of individual "windows"
              switch-applications = [ ];
              switch-applications-backward = [ ];
              switch-group = [ ];
              switch-group-backward = [ ];
              switch-windows = [ "<Alt>Tab" ];
              switch-windows-backward = [ "<Shift><Alt>Tab" ];

              # Moving around workspaces
              switch-to-workspace-right = [
                "<Super>Tab"
                "<Ctrl><Super>Right"
              ];
              switch-to-workspace-left = [
                "<Super><Shift>Tab"
                "<Ctrl><Super>Left"
              ];
              switch-to-workspace-up = [ ]; # These default to Ctrl-Alt-Arrow which prevents vscode from using it
              switch-to-workspace-down = [ ];

              move-to-workspace-right = [
                "<Ctrl><Super>Tab"
                "<Ctrl><Super><Shift>Right"
              ];
              move-to-workspace-left = [
                "<Ctrl><Super><Shift>Tab"
                "<Ctrl><Super><Shift>Left"
              ];

              close = [
                "<Alt>F4"
                "<Super>q"
              ];

              toggle-fullscreen = [ "<Super>f" ];
            };

            "org/gnome/shell/keybindings" = {
              toggle-quick-settings = [ ]; # Defaults to Super+S
              toggle-message-tray = [ ]; # Defaults to Super+V
              toggle-application-view = [ ]; # Defaults to Super+A
              show-screen-recording-ui = [ "<Super>r" ];
            };

            "org/gnome/settings-daemon/plugins/media-keys" = {
              screenreader = [ ]; # Disable screenreader, defaults to Alt+Super+S
              help = [ ]; # Disable help, defaults to Super+F1
              touchpad-off-static = [ ]; # Defaults to XF86TouchpadOff = F23
              touchpad-on-static = [ ]; # Defaults to XF86TouchpadOn = F22
              screensaver = [ ]; # Defaults to Super+L
            };

            "org/gnome/mutter/keybindings" = {
              switch-monitor = [ ]; # Disable switching monitor, defaults to Super+P and XF86Display
            };

            # Desktop settings
            "org/gnome/desktop/interface" = {
              enable-hot-corners = false;
              text-scaling-factor = cfg.display.textScalingPercent / 100.0;
            };

            "org/gnome/mutter" = {
              edge-tiling = true;
              dynamic-workspaces = true;
              workspaces-only-on-primary = false;
            };

            "org/gnome/shell/window-switcher" = {
              current-workspace-only = true;
            };

            "org/gnome/shell" = {
              # Clear the default app drawer
              favorite-apps = [ ];
            };

            "org/gnome/desktop/app-folders" = {
              # Clear out all default folders in the app drawer
              folder-children = [ ];
            };

            # Touchpad
            "org/gnome/desktop/peripherals/touchpad" = {
              natural-scroll = true;
              two-finger-scrolling-enabled = true;
            };

            # System sounds
            "org/gnome/desktop/sound" = {
              event-sounds = false;
            };

            # Night light
            "org/gnome/settings-daemon/plugins/color" = {
              night-light-enabled = true;
              night-light-schedule-automatic = false;
              night-light-schedule-from = 21.0;
              night-light-schedule-to = 6.0;
              night-light-temperature = mkUint32 3400;
            };

            # Appearance
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
              gtk-enable-primary-paste = false;
            };

            # Trash settings
            "org/gnome/desktop/privacy" = {
              recent-files-max-age = 30;
              old-files-age = mkUint32 30;
              remove-old-temp-files = true;
              remove-old-trash-files = true;
            };

            "org/gnome/desktop/calendar" = {
              show-weekdate = true;
            };
          };
        };
    };
}
