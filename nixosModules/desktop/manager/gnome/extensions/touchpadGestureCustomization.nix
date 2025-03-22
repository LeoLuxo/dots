{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.ext.desktop.gnome.extensions.touchpadGestureCustomization;
in

{
  options.ext.desktop.gnome.extensions.touchpadGestureCustomization = {
    enable = lib.mkEnableOption "the touchpad gesture customization GNOME extension";
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;

    ext.hm =
      { lib, ... }:
      {
        home.packages = with pkgs; [
          gnomeExtensions.touchpad-gesture-customization
        ];

        dconf.settings = {
          "org/gnome/shell" = {
            enabled-extensions = [ "touchpad-gesture-customization@coooolapps.com'" ];
          };

          "org/gnome/shell/extensions/touchpad-gesture-customization" = {
            allow-minimize-window = true;
            enable-forward-back-gesture = false;
            enable-window-manipulation-gesture = false;
            pinch-3-finger-gesture = "NONE";
            pinch-4-finger-gesture = "NONE";
          };
        };
      };
  };
}
