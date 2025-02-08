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
  config = modules.mkIf (cfg.enable && lists.elem "gsconnect" cfg.extensions) {
    programs.dconf.enable = true;

    programs.kdeconnect = {
      enable = true;
      # KDE Connect implementation for Gnome Shell.
      package = pkgs.gnomeExtensions.gsconnect;
    };

    home-manager.users.${constants.user} =
      { lib, ... }:
      {
        dconf.settings = {
          "org/gnome/shell" = {
            enabled-extensions = [ "gsconnect@andyholmes.github.io" ];
          };
        };
      };
  };
}
