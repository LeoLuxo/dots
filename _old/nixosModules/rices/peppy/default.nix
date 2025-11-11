{
  nixosModules,
  lib,
  lib2,
  config,
  inputs,
  user,
  pkgs,
  ...
}:

let
  inherit (lib) options types;
  inherit (lib2) mkSubmodule toPascalCase;
in

{
  imports = with nixosModules; [
    inputs.catppuccin.nixosModules.catppuccin

    desktop.gnome.gnome
    desktop.gnome.extensions.ddterm
  ];

  options.rice.peppy = {
    enable = lib.mkOption {
      type = types.bool;
      default = false;
    };

    blur = {
      enable = lib.mkOption {
        type = types.bool;
        default = true;
      };

      app-blur = mkSubmodule {
        enable = lib.mkOption {
          type = types.bool;
          default = false;
        };
      };

      hacks-level = options.mkOption {
        type = types.enum [
          "high performance"
          "default"
          "no artifact"
        ];
        default = "default";
      };
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

    cursor = {
      size = options.mkOption {
        type = types.ints.unsigned;
        default = 32;
      };

      flavor = options.mkOption {
        type = types.enum [
          "latte"
          "frappe"
          "macchiato"
          "mocha"
        ];
        default = config.rice.peppy.theme.flavor;
      };

      accent = options.mkOption {
        type = types.enum [
          "dark"
          "light"

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
        default = "dark";
      };
    };
  };

  config =
    let
      flavor = config.rice.peppy.theme.flavor;
      accent = config.rice.peppy.theme.accent;
      name = "catppuccin-${config.rice.peppy.cursor.flavor}-${config.rice.peppy.cursor.accent}-cursors";
      package =
        pkgs.catppuccin-cursors."${config.rice.peppy.cursor.flavor}${toPascalCase config.rice.peppy.cursor.accent}";
    in
    {
      home-manager.users.${user} = {
        imports = [
          inputs.catppuccin.homeManagerModules.catppuccin
        ];

        # Enable catppuccin for gtk
        gtk = {
          enable = true;
          catppuccin = {
            enable = true;
            flavor = config.rice.peppy.theme.flavor;
            accent = config.rice.peppy.theme.accent;
            size = "standard";
            tweaks = [ "normal" ];
          };
        };

        home.pointerCursor = {
          inherit name package;

          size = config.rice.peppy.cursor.size;
          gtk.enable = true;
          x11.enable = true;
        };

        gtk.cursorTheme = {
          inherit name package;
        };
      };

      gnome.blur-my-shell = config.rice.peppy.blur;

      environment.variables = {
        XCURSOR_SIZE = config.rice.peppy.cursor.size;
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
