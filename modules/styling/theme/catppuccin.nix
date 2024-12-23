{
  config,
  lib,
  catppuccin,
  constants,
  ...
}:

let
  inherit (lib) modules options types;
  inherit (constants) user;
in

let
  cfg = config.styling.theme;
in
{
  imports = [
    catppuccin.nixosModules.catppuccin
  ];

  options.styling.theme = {
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

  config = modules.mkIf (cfg.enable && cfg.name == "catppuccin") {
    catppuccin = {
      # Enable the theme for all compatible apps
      enable = true;

      # Choose flavor
      flavor = cfg.flavor;
      accent = cfg.accent;
    };

    home-manager.users.${user} = {
      imports = [
        catppuccin.homeManagerModules.catppuccin
      ];

      # Enable catppuccin for gtk
      gtk = {
        enable = true;
        catppuccin = {
          enable = true;
          flavor = cfg.flavor;
          accent = cfg.accent;
          size = "standard";
          tweaks = [ "normal" ];
        };
      };
    };

    boot.plymouth.catppuccin.enable = false;
  };
}
