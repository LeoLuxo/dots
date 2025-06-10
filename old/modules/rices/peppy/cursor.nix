{
  config,
  lib,
  pkgs,
  constants,
  extraLib,
  ...
}:

let
  inherit (lib) options types;
  inherit (constants) user;
  inherit (extraLib) toPascalCase;
in

{
  options.rice.peppy.cursor = {
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
      cfg = config.rice.peppy.cursor;
      name = "catppuccin-${cfg.flavor}-${cfg.accent}-cursors";
      package = pkgs.catppuccin-cursors."${cfg.flavor}${toPascalCase cfg.accent}";
    in
    {
      home-manager.users.${user} = {
        home.pointerCursor = {
          inherit name package;

          size = cfg.size;
          gtk.enable = true;
          x11.enable = true;
        };

        gtk.cursorTheme = {
          inherit name package;
        };
      };

      environment.variables = {
        XCURSOR_SIZE = cfg.size;
      };
    };
}
