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
  config = modules.mkIf (cfg.enable && lists.elem "netSpeedSimplified" cfg.extensions) {
    programs.dconf.enable = true;

    home-manager.users.${constants.user} =
      { lib, ... }:
      {
        home.packages = with pkgs; [
          gnomeExtensions.net-speed-simplified
        ];

        dconf.settings = {
          "org/gnome/shell" = {
            enabled-extensions = [ "netspeedsimplified@prateekmedia.extension" ];
          };

          # "org/gnome/shell/extensions/netspeedsimplified" = {
          # };
        };
      };
  };
}
