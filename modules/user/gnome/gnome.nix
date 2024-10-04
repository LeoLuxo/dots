{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # For gnome settings
    dconf
  ];

  # Gnome settings via dconf
  # To figure out what settings I change, turn on `dconf watch /` and then change around settings
  dconf.settings = {
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

    # Built-in shortcuts
    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = [ ];
      switch-applications-backward = [ ];

      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
    };

    "org/gnome/shell/keybindings" = {
      toggle-quick-settings = [ ];
    };

    # Touchpad
    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = true;
      two-finger-scrolling-enabled = true;
    };

    # Windowing
    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
    };

    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = true;
    };

    "org/gnome/shell/window-switcher" = {
      current-workspace-only = true;
    };

    # System sounds
    "org/gnome/desktop/sound" = {
      event-sounds = false;
    };
  };
}
