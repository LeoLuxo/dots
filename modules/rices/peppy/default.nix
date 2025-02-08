{
  lib,
  config,

  inputs,
  constants,
  ...
}:

let
  inherit (lib) mkDefault options types;
  inherit (extraLib) mkEnable;
in

{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin

    ./gnome.nix
    ./cursor.nix
    ./bootscreen.nix
  ];

  options = {
    enable = mkEnable;

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
      home-manager.users.${constants.user} = {
        imports = [
          inputs.catppuccin.homeManagerModules.catppuccin
        ];
      };

      # Disable catppuccin for the bootloader
      boot.plymouth.catppuccin.enable = false;

      wallpaper = {
        enable = mkDefault true;
        image = mkDefault ./assets/NixOSCatppuccin.svg;
      };

      fonts.enable = true;
      terminal.ddterm.enable = true;
      shell.prompt.starship.enable = true;

      catppuccin = {
        # Enable the theme for all compatible apps
        enable = true;

        # Choose flavor
        inherit flavor accent;
      };

      # Apply catppuccin to certain apps
      syncedFiles = {
        "youtubeMusic/config.json".overrides = {
          options.themes = [ "${./assets/yt-music.css}" ];
        };

        "vesktop/vencord.json".overrides = {
          themeLinks = [
            "https://catppuccin.github.io/discord/dist/catppuccin-${flavor}-${accent}.theme.css"
          ];
        };

        "vscode/settings.json".overrides = {
          "workbench.colorTheme" = "Catppuccin Frappé";
          "catppuccin.accentColor" = "lavender";
          "workbench.iconTheme" = "material-icon-theme";
        };
      };

      # Install catppuccin extensions to vscode
      # home-manager.users.${constants.user} = {
      # home.activation."vscode-peppy" = ''
      #   ${pkgs.vscode}/bin/code \
      #     --install-extension ${./assets/Catppuccin.catppuccin-vsc-3.16.0.vsix} --force \
      #     --install-extension ${./assets/PKief.material-icon-theme-5.16.0.vsix} --force
      # '';
      #   home.activation."vscode-peppy" = ''
      #     ${pkgs.vscode}/bin/code \
      #       --install-extension Catppuccin.catppuccin-vsc --force \
      #       --install-extension PKief.material-icon-theme --force
      #   '';
      # };
    };
}
