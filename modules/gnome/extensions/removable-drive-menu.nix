{
  pkgs,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  programs.dconf.enable = true;

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;
    {
      home.packages = with pkgs; [
        gnomeExtensions.removable-drive-menu
      ];

      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "drive-menu@gnome-shell-extensions.gcampax.github.com" ];
        };
      };
    };
}
