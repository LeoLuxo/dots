{
  directories,
  lib,
  config,
  ...
}:

let
  inherit (lib) mkDefault options types;
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

  options.rice = {
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
  };

  config =
    let
      flavor = config.rice.theme.flavor;
      accent = config.rice.theme.accent;
    in
    {
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
            "https://catppuccin.github.io/discord/dist/catppuccin-${flavor}-${accent}.theme.css"
          ];
        };
      };
    };
}
