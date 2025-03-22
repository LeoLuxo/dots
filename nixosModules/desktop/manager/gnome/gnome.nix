{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib2) enabled disabled;
  inherit (lib) types;

  cfg = config.ext.desktop.gnome;
in
{
  options.ext.desktop.gnome = with lib2.options; {
    enable = lib.mkEnableOption "the GNOME desktop manager";

    power = mkSubmodule "Power management options." {
      buttonAction = mkEnum "The action to take when the power button is pressed." [
        "power off"
        "suspend"
        "hibernate"
        "nothing"
      ] "power off";

      confirmShutdown = mkOpt "Whether to confirm before shutting down the system." types.bool true;

      screenIdle = mkSubmodule "Screen idle options." {
        enable = lib.mkEnableOption "screen idle options";

        delay = mkOpt "The delay in seconds before the screen is turned off." types.ints.unsigned 300;
      };

      suspendIdle = mkSubmodule "Suspend idle options." {
        enable = lib.mkEnableOption "suspend idle options";

        delay = mkOpt "The delay in seconds before the system is suspended." types.ints.unsigned 1800;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    ext.desktop.gnome = {
      # Disabled for now, because it's not working properly.
      tripleBuffering = disabled;
      customApps = enabled;
    };

    ext.shell.aliases = {
      "find-shortcut" = "gsettings list-recursively | grep -i";
    };

    ext.desktop.defaultApps.backupTerminal = lib.mkDefault "kgx";
    ext.desktop.defaultApps.terminal = lib.mkOverride 1050 "kgx";

    # Base extensions that should be included by default imo
    ext.desktop.gnome.extensions.justPerfection = enabled;
    ext.desktop.gnome.extensions.removableDriveMenu = enabled;
    ext.desktop.gnome.extensions.appIndicator = enabled;
    ext.desktop.gnome.extensions.bluetoothQuickConnect = enabled;

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

    programs.dconf.enable = true;

    ext.hm =
      { lib, ... }:
      let
        inherit (lib.hm.gvariant) mkUint32;
      in
      {

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
            text-scaling-factor = 1.5;
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

          # Trash settings
          "org/gnome/desktop/privacy" = {
            recent-files-max-age = 30;
            old-files-age = mkUint32 30;
            remove-old-temp-files = true;
            remove-old-trash-files = true;
          };
        };
      };
  };
}
