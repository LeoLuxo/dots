{
  pkgs,
  config,

  user,
  ...
}:

{
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
  ];

  home-manager.users.${user} =
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
