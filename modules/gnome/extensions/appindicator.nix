{
  pkgs,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  programs.dconf.enable = true;

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;
    {
      home.packages = with pkgs; [
        gnomeExtensions.appindicator
      ];

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
