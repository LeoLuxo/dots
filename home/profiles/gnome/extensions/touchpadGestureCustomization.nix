{ pkgs, ... }:
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
}
