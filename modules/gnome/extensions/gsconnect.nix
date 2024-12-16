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

  programs.kdeconnect = {
    enable = true;
    # KDE Connect implementation for Gnome Shell.
    package = pkgs.gnomeExtensions.gsconnect;
  };

  home-manager.users.${user} =
    { lib, ... }:
    {
      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "gsconnect@andyholmes.github.io" ];
        };
      };
    };
}
