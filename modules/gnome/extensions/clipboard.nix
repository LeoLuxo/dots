{
  pkgs,
  user,
  lib,
  ...
}:

with lib;

{
  environment.systemPackages = with pkgs; [
    # Manage wallpapers with ease
    gnomeExtensions.clipboard-indicator
  ];

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;

    {
      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "wallhub@sakithb.github.io" ];
        };

        "org/gnome/shell/extensions/clipboard-indicator" = {
          toggle-menu = [ "<Super>v" ];
          next-entry = [ "<Super>down" ];
          previous-entry = [ "<Super>up" ];
        };

      };
    };
}
