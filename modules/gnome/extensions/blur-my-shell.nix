{
  pkgs,
  user,
  lib,
  ...
}:

with lib;

{
  environment.systemPackages = with pkgs; [
    # Adds a blur look to different parts of the GNOME Shell, including the top panel, dash and overview.
    gnomeExtensions.blur-my-shell
  ];

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;

    {
      dconf.settings = {
        "org/gnome/shell" = {
          # enabled-extensions = [ "wallhub@sakithb.github.io" ];
        };
      };
    };
}
