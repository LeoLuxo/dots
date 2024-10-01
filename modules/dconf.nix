{ ... }:
{
  dconf.settings = {
    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
    };

    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = true;
    };

    "org/gnome/shell/keybindings" = {
      toggle-quick-settings = [ ];
    };

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
      command = "screenshot";
      name = "Instant screenshot";
    };

    "org/gnome/shell/window-switcher" = {
      current-workspace-only = true;
    };

    "org/gnome/desktop/sound" = {
      event-sounds = false;
    };
  };
}
