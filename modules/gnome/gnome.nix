{ user, ... }:

{
  imports = [
    ./extensions/tray-icons.nix
    ./extensions/wallhub.nix
    ./extensions/clipboard.nix
    ./extensions/translator.nix
    ./extensions/emojis.nix
    ./extensions/blur-my-shell.nix
  ];

  # Enable and configure the X11 windowing system.
  # It's a bit weird because we're running gnome under wayland?
  services.xserver = {
    enable = true;

    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  home-manager.users.${user} = {
    dconf.settings = {
      # Default extensions
      "org/gnome/shell" = {
        enabled-extensions = [ "drive-menu@gnome-shell-extensions.gcampax.github.com" ];
      };

      # Custom shortcuts
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/screenshot/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
        binding = "<Super>t";
        command = "kgx";
        name = "GNOME Console";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/screenshot" = {
        binding = "<Super>s";
        command = "snip";
        name = "Instant screenshot";
      };

      # System shortcuts
      "org/gnome/desktop/wm/keybindings" = {
        # The default is Alt-tab to switch "apps" instead of individual "windows"
        switch-applications = [ ];
        switch-applications-backward = [ ];
        switch-windows = [ "<Alt>Tab" ];
        switch-windows-backward = [ "<Shift><Alt>Tab" ];

        # Moving around workspaces
        switch-to-workspace-right = [ "<Ctrl><Super>Right" ];
        switch-to-workspace-left = [ "<Ctrl><Super>Left" ];
        switch-to-workspace-up = [ ]; # These default to Ctrl-Alt-Arrow which prevents vscode from using it
        switch-to-workspace-down = [ ];

        move-to-workspace-right = [ "<Ctrl><Super><Shift>Right" ];
        move-to-workspace-left = [ "<Ctrl><Super><Shift>Left" ];

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

    };
  };
}
