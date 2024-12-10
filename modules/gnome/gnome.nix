{
  config,
  pkgs,
  user,
  mkGnomeKeybind,
  lib,
  mkBoolDefaultTrue,
  mkSubmodule,
  mkBoolDefaultFalse,
  ...
}:
{
  imports = [
    ./triple-buffering.nix

    (mkGnomeKeybind {
      name = "GNOME Console";
      binding = "<Super>t";
      command = "kgx";
    })
  ];

  options.gnome = with lib; {
    enable = mkBoolDefaultTrue;

    power = mkSubmodule {
      button-action = mkOption {
        type = types.enum [
          "power off"
          "suspend"
          "hibernate"
          "nothing"
        ];
        default = "power off";
      };

      confirm-shutdown = mkBoolDefaultTrue;

      screen-idle = mkSubmodule {
        enable = mkBoolDefaultTrue;

        delay = mkOption {
          type = types.ints.unsigned;
          default = 300;
        };
      };

      suspend-idle = mkSubmodule {
        enable = mkBoolDefaultFalse;

        delay = mkOption {
          type = types.ints.unsigned;
          default = 1800;
        };
      };
    };
  };

  config =
    with lib;
    let
      cfg = config.gnome;
    in
    mkIf cfg.enable {

      # Enable and configure the X11 windowing system.
      # It's a bit weird because we're running gnome under wayland?
      services.xserver = {
        enable = true;

        # Enable the GNOME Desktop Environment.
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };

      programs.dconf.enable = true;

      home-manager.users.${user} =
        { lib, ... }:
        with lib.hm.gvariant;

        {
          home.packages = with pkgs; [
            gnomeExtensions.removable-drive-menu
            gnomeExtensions.appindicator
          ];

          dconf.settings = {
            # Base extensions
            "org/gnome/shell" = {
              enabled-extensions = [
                "drive-menu@gnome-shell-extensions.gcampax.github.com"
                "appindicatorsupport@rgcjonas.gmail.com"
              ];
            };

            # Power settings
            "org/gnome/settings-daemon/plugins/power" = {
              power-button-action =
                {
                  "power off" = "interactive";
                  "suspend" = "suspend";
                  "hibernate" = "hibernate";
                  "nothing" = "nothing";
                }
                .${cfg.power.button-action};

              sleep-inactive-ac-type = if cfg.power.suspend-idle.enable then "suspend" else "nothing";
              sleep-inactive-ac-timeout = cfg.power.suspend-idle.delay;
            };

            "org/gnome/gnome-session" = {
              logout-prompt = cfg.power.confirm-shutdown;
            };

            "org/gnome/desktop/session" = {
              idle-delay = mkUint32 (if cfg.power.screen-idle.enable then cfg.power.screen-idle.delay else 0);
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
            };

            "org/gnome/shell/keybindings" = {
              # Defaults to Super+S
              toggle-quick-settings = [ ];

              # Defaults to Super+V
              toggle-message-tray = [ ];
            };

            # Desktop settings
            "org/gnome/desktop/interface" = {
              enable-hot-corners = false;
            };

            "org/gnome/mutter" = {
              edge-tiling = true;
              dynamic-workspaces = true;
              workspaces-only-on-primary = true;
            };

            "org/gnome/shell/window-switcher" = {
              current-workspace-only = true;
            };

            "org/gnome/shell" = {
              # Clear the default app drawer
              favorite-apps = [ ];
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
              night-light-temperature = mkUint32 2700;
            };

            # Appearance
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
              gtk-enable-primary-paste = false;
            };

            # Base extension settings
            "org/gnome/shell/extensions/appindicator" = {
              icon-size = 0;
              tray-pos = "left";
            };
          };
        };
    };
}
