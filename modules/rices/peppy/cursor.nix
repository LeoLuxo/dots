{
  config,
  lib,
  pkgs,
  constants,
  extraLib,
  cfg,
  ...
}:

let
  inherit (lib) options types modules;
  inherit (extraLib) toPascalCase;
in

{
  options.cursor = {
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

  config =
    let
      name = "catppuccin-${cfg.cursor.flavor}-${cfg.cursor.accent}-cursors";
      package = pkgs.catppuccin-cursors."${cfg.cursor.flavor}${toPascalCase cfg.cursor.accent}";
    in
    modules.mkIf cfg.enable {
      home-manager.users.${constants.user} = {
        home.pointerCursor = {
          inherit name package;

          size = cfg.cursor.size;
          gtk.enable = true;
          x11.enable = true;
        };

        gtk.cursorTheme = {
          inherit name package;
        };
      };

      environment.variables = {
        XCURSOR_SIZE = cfg.cursor.size;
      };
    };
}
