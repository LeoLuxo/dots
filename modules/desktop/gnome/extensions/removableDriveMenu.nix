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
  config = modules.mkIf (cfg.enable && lists.elem "removableDriveMenu" cfg.extensions) {
    programs.dconf.enable = true;

    home-manager.users.${constants.user} =
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
