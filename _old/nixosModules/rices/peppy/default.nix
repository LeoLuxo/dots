{
  nixosModules,
  lib,
  config,
  inputs,
  user,
  ...
}:

let
  inherit (lib) mkDefault options types;

in

{
  imports = with nixosModules; [
    inputs.catppuccin.nixosModules.catppuccin

    ./gnome.nix
    ./cursor.nix

    desktop.gnome.extensions.ddterm
  ];

  options.rice.peppy = {
    enable = lib.mkOption {
      type = types.bool;
      default = false;
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
  };

  config =
    let
      flavor = config.rice.peppy.theme.flavor;
      accent = config.rice.peppy.theme.accent;
    in
    {
      home-manager.users.${user} = {
        imports = [
          inputs.catppuccin.homeManagerModules.catppuccin
        ];
      };

      # Disable catppuccin for the bootloader
      boot.plymouth.catppuccin.enable = false;

      # wallpaper = {
      #   enable = mkDefault true;
      #   image = mkDefault ./assets/NixOSCatppuccin.svg;
      # };

      catppuccin = {
        # Enable the theme for all compatible apps
        enable = true;

        # Choose flavor
        inherit flavor accent;
      };

      # Apply catppuccin to certain apps
      # syncedFiles.overrides = {
      #   "youtube-music/config.json" = {
      #     options.themes = [ "${./assets/yt-music.css}" ];
      #   };

      #   "vesktop/vencord.json" = {
      #     themeLinks = [
      #       "https://catppuccin.github.io/discord/dist/catppuccin-${flavor}-${accent}.theme.css"
      #     ];
      #   };

      #   "vscode/settings.json" = {
      #     "workbench.colorTheme" = "Catppuccin Frappé";
      #     "catppuccin.accentColor" = "lavender";
      #     "workbench.iconTheme" = "material-icon-theme";
      #   };
      # };

      # Install catppuccin extensions to vscode
      # home-manager.users.${user} = {
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
