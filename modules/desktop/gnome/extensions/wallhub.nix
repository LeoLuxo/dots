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
  config = modules.mkIf (cfg.enable && lists.elem "wallhub" cfg.extensions) {
    programs.dconf.enable = true;

    home-manager.users.${constants.user} =
      { lib, ... }:
      {
        home.packages = with pkgs; [
          gnomeExtensions.wallhub
        ];

        dconf.settings = {
          "org/gnome/shell" = {
            enabled-extensions = [ "wallhub@sakithb.github.io" ];
          };
        };
      };
  };
}
