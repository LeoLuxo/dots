{
  directories,
  lib,
  ...
}:

let
  inherit (lib) mkDefault;
in

{
  imports = with directories.modules; [
    wallpaper
    fonts

    ./cursor.nix
    ./gtk.nix
    ./bootscreen.nix

    desktop.gnome.gnome
    desktop.gnome.extensions.blur-my-shell
    desktop.gnome.extensions.clipboard-indicator
    desktop.gnome.extensions.gsconnect
    desktop.gnome.extensions.rounded-corners
    # desktop.gnome.extensions.emojis
    # desktop.gnome.extensions.weather
    desktop.gnome.extensions.system-monitor
    desktop.gnome.extensions.media-controls
    desktop.gnome.extensions.burn-my-windows

    terminal.ddterm
    shell.prompt.starship
  ];

  wallpaper = {
    enable = mkDefault true;
    image = mkDefault directories.wallpapers.static."nixos-catppuccin";
  };

  syncedFiles.overrides = {
    "youtube-music/config.json" = {
      options.themes = [ "${./yt-music.css}" ];
    };

    "vesktop/vencord.json" = {
      themeLinks = [
        "https://catppuccin.github.io/discord/dist/catppuccin-frappe-blue.theme.css"
      ];
    };
  };
}
