{
  config,
  lib,
  catppuccin,
  constants,
  extra-libs,
  directories,
  ...
}:

let
  inherit (lib) options types;
  inherit (constants) user;
  inherit (extra-libs) mkBoolDefaultTrue mkBoolDefaultFalse mkSubmodule;
in

{
  options.rice.peppy = {
    blur = {
      enable = mkBoolDefaultTrue;
      app-blur = mkSubmodule {
        enable = mkBoolDefaultFalse;
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
  };

  imports = with directories.modules; [
    catppuccin.nixosModules.catppuccin

    desktop.gnome.gnome
    desktop.gnome.extensions.blur-my-shell
    desktop.gnome.extensions.clipboard-indicator
    desktop.gnome.extensions.gsconnect
    desktop.gnome.extensions.rounded-corners
    # desktop.gnome.extensions.emojis
    # desktop.gnome.extensions.weather
    desktop.gnome.extensions.system-monitor
    desktop.gnome.extensions.media-controls
    desktop.gnome.extensions.burn-my-windows
  ];

  config =
    let
      cfg = config.rice.peppy;
    in
    {
      catppuccin = {
        # Enable the theme for all compatible apps
        enable = true;

        # Choose flavor
        flavor = cfg.theme.flavor;
        accent = cfg.theme.accent;
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
            flavor = cfg.theme.flavor;
            accent = cfg.theme.accent;
            size = "standard";
            tweaks = [ "normal" ];
          };
        };
      };

      boot.plymouth.catppuccin.enable = false;

      gnome.blur-my-shell = cfg.blur;
    };
}
