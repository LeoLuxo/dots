{
  directories,
  lib,
  config,
  constants,
  nix-vscode-extensions,
  extra-libs,
  ...
}:

let
  inherit (lib) mkDefault options types;
  inherit (constants) user system;
  inherit (extra-libs) mkBoolDefaultTrue;
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

  options.rice.peppy = {
    enable = mkBoolDefaultTrue;

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
      flavor = config.rice.peppy.theme.flavor;
      accent = config.rice.peppy.theme.accent;
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

        "vscode/settings.json" = {
          "workbench.colorTheme" = "Catppuccin Frappé";
          "catppuccin.accentColor" = "lavender";
        };
      };

      # TODO Add catppuccin extension to vscode
      # home-manager.users.${user} = {
      #   programs.vscode.extensions = with nix-vscode-extensions.extensions.${system}.vscode-marketplace; [
      #     catppuccin.catppuccin-vsc
      #   ];
      # };
    };
}
