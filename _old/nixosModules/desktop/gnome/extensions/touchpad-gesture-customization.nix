{
  pkgs,
  config,

  ...
}:

{
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    gnomeExtensions.touchpad-gesture-customization
  ];

  home-manager.users.${config.my.user.name} =
    { lib, ... }:
    {

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
}
