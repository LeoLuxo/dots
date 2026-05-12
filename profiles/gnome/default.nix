{
  inputs,
  lib,
  lib2,
  config,
  pkgs,
  user,
  picture ? null,
  ...
}:

let
  inherit (lib) options types;
  inherit (lib2) mkSubmodule;

  cfg = config.gnome;
in

{
  options.gnome = {
    power = mkSubmodule {
      buttonAction = options.mkOption {
        description = "the action to take when the power button is pressed";
        type = types.enum [
          "power off"
          "suspend"
          "hibernate"
          "nothing"
        ];
        default = "power off";
      };

      confirmShutdown = lib.mkOption {
        description = "whether to ask for confirmation when logging out or shutting down";
        type = types.bool;
        default = true;
      };

      screenIdle = mkSubmodule {
        enable = lib.mkOption {
          description = "whether to turn off the screen after a period of inactivity";
          type = types.bool;
          default = true;
        };

        delay = options.mkOption {
          description = "the time of inactivity (in seconds) before the screen is turned off";
          type = types.ints.unsigned;
          default = 300;
        };
      };

      suspendIdlePluggedIn = mkSubmodule {
        enable = lib.mkOption {
          description = "whether to suspend the computer after a period of inactivity while on AC power";
          type = types.bool;
          default = false;
        };

        delay = options.mkOption {
          description = "the time of inactivity (in seconds) before the computer is suspended";
          type = types.ints.unsigned;
          default = 1800;
        };
      };

      suspendIdleOnBattery = mkSubmodule {
        enable = lib.mkOption {
          description = "whether to suspend the computer after a period of inactivity while on battery power (irrelevant for desktops)";
          type = types.bool;
          default = true;
        };

        delay = options.mkOption {
          description = "the time of inactivity (in seconds) before the computer is suspended";
          type = types.ints.unsigned;
          default = 1800;
        };
      };
    };

    textScalingPercent = options.mkOption {
      description = "the text scaling factor as a percentage (100 = normal size)";
      type = types.ints.unsigned;
      default = 100;
    };

    accentColor = options.mkOption {
      description = "the system accent color";
      type = types.enum [
        "blue"
        "teal"
        "green"
        "yellow"
        "orange"
        "red"
        "pink"
        "purple"
        "slate"
      ];
      default = "blue";
    };

    cursorSize = options.mkOption {
      description = "the size of the mouse cursor";
      type = types.ints.unsigned;
      default = 32;
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
        default = cfg.theme.flavor;
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

  imports = [
    # Triple buffering fork thing, broken atm
    # ./tripleBuffering.nix

    # Default gnome apps
    ./defaultApps.nix

    # Base extensions that should be included by default
    ./extensions/justPerfection.nix
    ./extensions/removableDriveMenu.nix
    ./extensions/appindicator.nix
    ./extensions/bluetoothQuickConnect.nix

    # My extensions
    ./extensions/ddterm.nix
    ./extensions/blurMyShell.nix
    ./extensions/clipboardIndicator.nix
    ./extensions/gsconnect.nix
    ./extensions/roundedCorners.nix
    ./extensions/systemMonitor.nix
    ./extensions/mediaControls.nix
    ./extensions/burnMyWindows.nix
    ./extensions/touchpadGestureCustomization.nix
  ];

  config =

    let
      gdmTheme = pkgs.writeTextFile {
        name = "gdm-glass-theme";
        destination = "/share/gnome-shell/theme/gdm3.css";
        text = ''
            -gtk-icon-style: symbolic;
          #lockDialogGroup {
            background: radial-gradient(ellipse at 30% 40%,
                          rgba(180, 200, 230, 0.18) 0%,
                          rgba(10,  12,  20,  0.82) 70%),
                        radial-gradient(ellipse at 80% 80%,
                          rgba(120, 160, 220, 0.12) 0%,
                          transparent 60%);
            background-color: #0d0f18;
          }

          .login-dialog {
            background:       rgba(255, 255, 255, 0.06);
            border:           1px solid rgba(255, 255, 255, 0.14);
            border-radius:    24px;
            box-shadow:       0 8px 48px rgba(0, 0, 0, 0.55),
                              inset 0 1px 0 rgba(255, 255, 255, 0.12);
            padding:          48px 40px;
            /* Mutter/Shell must have blur-behind enabled for backdrop-filter */
            color:            rgba(240, 244, 255, 0.92);
          }

          .login-dialog-user-list {
            spacing: 12px;
          }

          .login-dialog-user-list-item {
            border-radius:    16px;
            padding:          10px 14px;
            transition:       background 200ms ease;
          }

          .login-dialog-user-list-item:hover,
          .login-dialog-user-list-item:focus {
            background: rgba(255, 255, 255, 0.09);
            border:     1px solid rgba(255, 255, 255, 0.18);
          }

          .login-dialog-user-list-item:selected {
            background: rgba(160, 195, 255, 0.15);
            border:     1px solid rgba(160, 195, 255, 0.30);
          }

          .login-dialog-username-label {
            color:       rgba(230, 238, 255, 0.95);
            font-size:   15px;
            font-weight: 500;
          }

          .login-dialog-prompt-label {
            color:       rgba(180, 200, 240, 0.75);
            font-size:   12px;
            font-weight: 400;
            letter-spacing: 1.5px;
            text-transform: uppercase;
          }

          .login-dialog-prompt-entry {
            background:    rgba(255, 255, 255, 0.07);
            border:        1px solid rgba(255, 255, 255, 0.16);
            border-radius: 12px;
            color:         rgba(230, 238, 255, 0.95);
            font-size:     14px;
            padding:       12px 16px;
            caret-color:   rgba(160, 195, 255, 0.9);
            transition:    border 150ms ease, background 150ms ease;
          }

          .login-dialog-prompt-entry:focus {
            background: rgba(255, 255, 255, 0.11);
            border:     1px solid rgba(160, 195, 255, 0.45);
            box-shadow: 0 0 0 3px rgba(120, 170, 255, 0.12);
          }

          .login-dialog-button {
            background:    rgba(160, 195, 255, 0.15);
            border:        1px solid rgba(160, 195, 255, 0.28);
            border-radius: 12px;
            color:         rgba(220, 235, 255, 0.95);
            font-size:     13px;
            font-weight:   500;
            padding:       10px 24px;
            transition:    background 150ms ease, box-shadow 150ms ease;
          }

          .login-dialog-button:hover {
            background: rgba(160, 195, 255, 0.25);
            box-shadow: 0 4px 20px rgba(100, 160, 255, 0.20);
          }

          .login-dialog-button:active {
            background: rgba(160, 195, 255, 0.35);
          }

          .user-icon {
            border:        2px solid rgba(255, 255, 255, 0.18);
            border-radius: 50%;
            box-shadow:    0 4px 24px rgba(0, 0, 0, 0.40),
                           0 0 0 4px rgba(255, 255, 255, 0.05);
          }

          .login-dialog-message-label {
            color:       rgba(255, 160, 140, 0.90);
            font-size:   12px;
            font-weight: 400;
          }

          .clock {
            color:         rgba(220, 232, 255, 0.88);
            font-size:     64px;
            font-weight:   200;

          .clock-label {
            color:         rgba(180, 200, 240, 0.65);
            font-size:     16px;
            font-weight:   300;
            letter-spacing: 3px;
            text-transform: uppercase;
          }

          .login-dialog-sessionlist-button,
          .login-dialog-notlistlisted-button {
            background:    rgba(255, 255, 255, 0.05);
            border:        1px solid rgba(255, 255, 255, 0.10);
            border-radius: 10px;
            color:         rgba(200, 216, 255, 0.75);
            padding:       8px 14px;
            transition:    background 150ms ease;
          }

          .login-dialog-sessionlist-button:hover,
          .login-dialog-notlistlisted-button:hover {
            background: rgba(255, 255, 255, 0.10);
            color:      rgba(220, 235, 255, 0.95);
          }
        '';
      };
    in
    {
      environment.etc = {
        "gdm/gdm3.css".source = "${gdmTheme}/share/gnome-shell/theme/gdm3.css";
      };

      programs.dconf.enable = true;

      # Configure thumbnailers
      environment.pathsToLink = [ "share/thumbnailers" ];
      environment.systemPackages = [
        # Video/audio
        pkgs.ffmpeg-headless
        pkgs.ffmpegthumbnailer
        pkgs.totem

        # HEIC images
        pkgs.libheif
        pkgs.libheif.out
      ];

      # Add picture for the GDM login screen (for the gnome lock screen ~/.face is sufficient)
      system.activationScripts."profile-picture" = lib.mkIf (picture != null) ''
        mkdir -p /var/lib/AccountsService/icons
        cp -f ${picture} /var/lib/AccountsService/icons/${user}

        mkdir -p /var/lib/AccountsService/users
        cat > /var/lib/AccountsService/users/${user} <<EOF
        [User]
        Icon=/var/lib/AccountsService/icons/${user}
        EOF
      '';

      # Enable the GNOME Desktop Environment
      services.desktopManager.gnome = {
        enable = true;

        extraGSettingsOverridePackages = [ pkgs.mutter ];
        extraGSettingsOverrides = ''
          [org.gnome.mutter]
          experimental-features=['variable-refresh-rate', 'scale-monitor-framebuffer']
        '';
      };

      # Enable Gnome's display manager
      services.displayManager.gdm = {
        enable = true;
        wayland = true;
        settings = {
          greeter = {
            IncludeAll = true;
          };
        };
      };

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

      environment.variables = {
        XCURSOR_SIZE = cfg.cursor.size;
      };

      home-manager.users.${user} =
        { lib, user, ... }:
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
                .${cfg.power.buttonAction};

              sleep-inactive-ac-type = if cfg.power.suspendIdlePluggedIn.enable then "suspend" else "nothing";
              sleep-inactive-ac-timeout = cfg.power.suspendIdlePluggedIn.delay;

              sleep-inactive-battery-type =
                if cfg.power.suspendIdleOnBattery.enable then "suspend" else "nothing";
              sleep-inactive-battery-timeout = cfg.power.suspendIdleOnBattery.delay;

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
              show-screenshot-ui = [ "<Super>s" ];
            };

            "org/gnome/settings-daemon/plugins/media-keys" = {
              screenreader = [ ]; # Disable screenreader, defaults to Alt+Super+S
              help = [ ]; # Disable help, defaults to Super+F1
              touchpad-off-static = [ ]; # Defaults to XF86TouchpadOff = F23
              touchpad-on-static = [ ]; # Defaults to XF86TouchpadOn = F22
              screensaver = [ "<Super>l" ]; # Defaults to Super+L
            };

            "org/gnome/mutter/keybindings" = {
              switch-monitor = [ ]; # Disable switching monitor, defaults to Super+P and XF86Display
            };

            # Desktop settings
            "org/gnome/desktop/interface" = {
              enable-hot-corners = false;
              text-scaling-factor = cfg.textScalingPercent / 100.0;
              accent-color = cfg.accentColor;
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
              allow-volume-above-100-percent = true;
            };

            # Night light
            "org/gnome/settings-daemon/plugins/color" = {
              night-light-enabled = true;
              night-light-schedule-automatic = false;
              night-light-schedule-from = 21.0;
              night-light-schedule-to = 6.0;
              night-light-temperature = mkUint32 3400;
            };

            "org/gnome/desktop/a11y/interface" = {
              high-contrast = false;
              show-status-shapes = true; # On-off shapes, indicate button status using shape additionally to color
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

            # Calendar and locale settings
            "org/gnome/desktop/calendar" = {
              show-weekdate = true;
            };

            "system/locale" = {
              region = "en_DK.UTF-8";
            };
          };
        };
    };
}
