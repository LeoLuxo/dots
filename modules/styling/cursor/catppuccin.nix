{
  config,
  lib,
  pkgs,
  constants,
  extra-libs,
  ...
}:

let
  inherit (lib) modules options types;
  inherit (constants) user;
  inherit (extra-libs) toPascalCase;
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
      name = "catppuccin-${cfg.flavor}-${cfg.accent}-cursors";
      package = pkgs.catppuccin-cursors."${cfg.flavor}${toPascalCase cfg.accent}";
    in
    {
      home-manager.users.${user} = {
        home.pointerCursor = {
          inherit name package;
          inherit (cfg) size;

          gtk.enable = true;
          x11.enable = true;
        };

        gtk.cursorTheme = {
          inherit name package;
        };
      };
    }
  );
}
