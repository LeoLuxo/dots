{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.my.desktop.gnome.extensions.appIndicator;
in

{
  options.my.desktop.gnome.extensions.appIndicator = {
    enable = lib.mkEnableOption "the appindicator GNOME extension";
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;

    my.hm =
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
