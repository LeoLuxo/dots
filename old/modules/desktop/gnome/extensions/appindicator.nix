{
  pkgs,
  config,
  constants,
  ...
}:

{
  programs.dconf.enable = true;

  ext.packages = with pkgs; [
    gnomeExtensions.appindicator
  ];

  home-manager.users.${config.ext.system.user.name} =
    { lib, ... }:
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
