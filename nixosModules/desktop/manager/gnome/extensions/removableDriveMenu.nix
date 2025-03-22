{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.ext.desktop.gnome.extensions.removableDriveMenu;
in

{
  options.ext.desktop.gnome.extensions.removableDriveMenu = {
    enable = lib.mkEnableOption "the removable drive menu GNOME extension";
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;

    ext.hm =
      { lib, ... }:
      {
        home.packages = with pkgs; [
          gnomeExtensions.removable-drive-menu
        ];

        dconf.settings = {
          "org/gnome/shell" = {
            enabled-extensions = [ "drive-menu@gnome-shell-extensions.gcampax.github.com" ];
          };
        };
      };
  };
}
