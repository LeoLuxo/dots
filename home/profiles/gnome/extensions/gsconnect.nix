{ pkgs, ... }:
{
  services.kdeconnect = {
    enable = true;
    # KDE Connect implementation for Gnome Shell.
    package = pkgs.gnomeExtensions.gsconnect;
  };

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [ "gsconnect@andyholmes.github.io" ];
    };
  };
}
