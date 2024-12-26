{
  config,
  lib,
  constants,
  ...
}:

let
  inherit (constants) user;
in

let
  inherit (lib) modules;
  cfg = config.gnome;
in
modules.mkIf cfg.enable {
  programs.dconf.enable = true;

  home-manager.users.${user} =
    { lib, ... }:
    let
      inherit (lib.hm.gvariant) mkUint32;
    in
    {
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
          night-light-temperature = mkUint32 2700;
        };

        # Appearance
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-enable-primary-paste = false;
        };
      };
    };
}
