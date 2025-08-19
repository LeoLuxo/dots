{
  config,
  lib,
  lib2,
  nixosModulesOld,
  ...
}:

let
  inherit (lib) options types;
  inherit (lib2) mkSubmodule;
in

{
  options.rice.peppy = {
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
  };

  imports = with nixosModulesOld; [
    desktop.gnome.gnome
    desktop.gnome.extensions.blur-my-shell
    desktop.gnome.extensions.clipboard-indicator
    desktop.gnome.extensions.gsconnect
    desktop.gnome.extensions.rounded-corners
    desktop.gnome.extensions.system-monitor
    desktop.gnome.extensions.media-controls
    desktop.gnome.extensions.burn-my-windows
    desktop.gnome.extensions.touchpad-gesture-customization
    # desktop.gnome.extensions.emojis
    # desktop.gnome.extensions.weather
    # desktop.gnome.extensions.net-speed-simplified
  ];

  config =
    let
      cfg = config.rice.peppy;
    in
    {
      home-manager.users.${config.my.user.name} = {
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

      gnome.blur-my-shell = cfg.blur;
    };
}
