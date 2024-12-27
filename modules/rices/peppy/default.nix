{
  directories,
  lib,
  config,
  constants,
  extra-libs,
  pkgs,
  ...
}:

let
  inherit (lib) mkDefault options types;
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
          "workbench.iconTheme" = "material-icon-theme";
        };
      };

      # Install catppuccin extensions to vscode
      home-manager.users.${constants.user} = {
        home.activation."vscode-catppuccin" = ''
          ${pkgs.vscode}/bin/code \
            --install-extension catppuccin.catppuccin-vsc --force \
            --install-extension PKief.material-icon-theme --force
        '';
      };
    };
}
