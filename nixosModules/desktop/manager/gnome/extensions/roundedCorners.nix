{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.ext.desktop.gnome.extensions.roundedCorners;
in

{
  options.ext.desktop.gnome.extensions.roundedCorners = {
    enable = lib.mkEnableOption "the rounded corners GNOME extension";
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;

    ext.hm =
      { lib, ... }:
      {
        home.packages = with pkgs; [
          gnomeExtensions.rounded-window-corners-reborn
        ];

        dconf.settings = {
          "org/gnome/shell" = {
            enabled-extensions = [ "rounded-window-corners@fxgn" ];
          };

          "org/gnome/shell/extensions/rounded-window-corners-reborn" = {
            skip-libadwaita-app = false;
            enable-preferences-entry = false;
            black-list = [ "com.github.amezin.ddterm" ];
          };
        };
      };
  };
}
