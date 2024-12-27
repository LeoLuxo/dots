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

    ./gnome.nix
    ./cursor.nix
    ./bootscreen.nix

    terminal.ddterm
    shell.prompt.starship
  ];

  wallpaper = {
    enable = mkDefault true;
    image = mkDefault directories.wallpapers.static."nixos-catppuccin";
  };

  # Apply catppuccin to certain apps
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
