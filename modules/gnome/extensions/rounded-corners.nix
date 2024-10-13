{
  pkgs,
  user,
  lib,
  ...
}:

with lib;

{
  environment.systemPackages = with pkgs; [
    dconf
    gnomeExtensions.rounded-window-corners-reborn
  ];

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;

    {
      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "rounded-window-corners@fxgn" ];
        };

      };
    };
}
