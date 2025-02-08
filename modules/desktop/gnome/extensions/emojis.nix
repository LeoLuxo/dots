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
  config = modules.mkIf (cfg.enable && lists.elem "emojis" cfg.extensions) {
    programs.dconf.enable = true;

    home-manager.users.${constants.user} =
      { lib, ... }:
      {
        home.packages = with pkgs; [
          gnomeExtensions.emoji-copy
        ];

        dconf.settings = {
          "org/gnome/shell" = {
            # enabled-extensions = [ "clipboard-indicator@tudmotu.com" ];
          };
        };
      };
  };
}
