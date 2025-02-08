{
  pkgs,
  constants,
  config,
  lib,
  ...
}:

let
  inherit (lib) modules lists;
in

{
  config = modules.mkIf (cfg.enable && lists.elem "appIndicator" cfg.extensions) {
    programs.dconf.enable = true;

    home-manager.users.${constants.user} =
      { lib, ... }:
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
  };
}
