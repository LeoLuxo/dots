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

    # Tweak Tool to Customize GNOME Shell, Change the Behavior and Disable UI Elements.
    gnomeExtensions.just-perfection
  ];

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;

    {
      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "wallhub@sakithb.github.io" ];
        };
      };
    };
}
