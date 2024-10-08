{
  pkgs,
  user,
  lib,
  ...
}:

with lib;

{
  environment.systemPackages = with pkgs; [
    # Adds AppIndicator, KStatusNotifierItem and legacy Tray icons support to the Shell
    # (Because gnome by default doesn't support tray icons)
    gnomeExtensions.appindicator
  ];

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;

    {
      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "appindicatorsupport@rgcjonas.gmail.com" ];
        };

        "org/gnome/shell/extensions/appindicator" = {
          icon-size = 0;
          tray-pos = "left";
        };
      };
    };
}
