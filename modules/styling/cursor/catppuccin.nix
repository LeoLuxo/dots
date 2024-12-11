{
  config,
  lib,
  pkgs,
  constants,
  ...
}:

let
  inherit (lib) modules options types;
  inherit (constants) user;
in

let
  cfg = config.styling.cursor;
in
{

  options.styling.cursor = {
    flavor = options.mkOption {
      type = types.enum [
        "latte"
        "frappe"
        "macchiato"
        "mocha"
      ];
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
    };
  };

  config = modules.mkIf (cfg.enable && cfg.name == "catppuccin") (
    let
      toCamelCase =
        # Not true CamelCase, only first letter is capitalized
        string:
        let
          head = lib.toUpper (lib.substring 0 1 string);
          tail = lib.substring 1 (-1) string;
        in
        head + tail;

      name = "catppuccin-${cfg.flavor}-${cfg.accent}-cursors";
      package = pkgs.catppuccin-cursors."${cfg.flavor}${toCamelCase cfg.accent}";
    in
    {
      home-manager.users.${user} = {
        home.pointerCursor = {
          inherit name package;
          gtk.enable = true;
          x11.enable = true;
          size = 16;
        };

        gtk.cursorTheme = {
          inherit name package;
        };
      };
    }
  );
}
