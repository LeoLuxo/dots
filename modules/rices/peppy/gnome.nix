{
  lib,
  constants,
  extraLib,
  cfg,
  ...
}:

let
  inherit (lib) options types modules;
  inherit (extraLib) mkBoolDefaultTrue mkEnable mkSubmodule;
in

{
  options = {
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

  config = modules.mkIf cfg.enable {
    home-manager.users.${constants.user} = {
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

    desktop.gnome = {
      enable = true;

      blur-my-shell = cfg.blur;

      extensions = [
        "blur-my-shell"
        "clipboard-indicator"
        "gsconnect"
        "rounded-corners"
        "system-monitor"
        "media-controls"
        "burn-my-windows"
        # "emojis"
        # "weather"
        # "net-speed-simplified"
      ];
    };

  };
}
