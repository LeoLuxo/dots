{
  pkgs,
  user,
  lib,
  ...
}:

with lib;

{
  programs.dconf.enable = true;

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;
    {
      home.packages = with pkgs; [
        gnomeExtensions.rounded-window-corners-reborn
      ];

      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "rounded-window-corners@fxgn" ];
        };

      };
    };
}
