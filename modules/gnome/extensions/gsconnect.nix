{
  pkgs,
  user,
  ...
}:

{
  programs.dconf.enable = true;

  programs.kdeconnect = {
    enable = true;
    # KDE Connect implementation for Gnome Shell.
    package = pkgs.gnomeExtensions.gsconnect;
  };

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;
    {
      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "gsconnect@andyholmes.github.io" ];
        };
      };
    };
}