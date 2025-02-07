{
  config,
  lib,
  constants,
  extraLib,
  nixosModules,
  ...
}:

let
  inherit (lib) options types;
  inherit (constants) user;
  inherit (extraLib) mkBoolDefaultTrue mkEnable mkSubmodule;
in

{
  options.rice.peppy = {
    blur = {
      enable = mkBoolDefaultTrue;

      app-blur = mkSubmodule {
        enable = mkEnable;
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

  imports = with nixosModules; [
    desktop.gnome.gnome
    desktop.gnome.extensions.blur-my-shell
    desktop.gnome.extensions.clipboard-indicator
    desktop.gnome.extensions.gsconnect
    desktop.gnome.extensions.rounded-corners
    desktop.gnome.extensions.system-monitor
    desktop.gnome.extensions.media-controls
    desktop.gnome.extensions.burn-my-windows
    # desktop.gnome.extensions.emojis
    # desktop.gnome.extensions.weather
    # desktop.gnome.extensions.net-speed-simplified
  ];

  config =
    let
      cfg = config.rice.peppy;
    in
    {
      home-manager.users.${user} = {
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
