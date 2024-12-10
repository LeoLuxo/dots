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
        gnomeExtensions.burn-my-windows
      ];

      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "burn-my-windows@schneegans.github.com" ];
        };

      };
    };
}
