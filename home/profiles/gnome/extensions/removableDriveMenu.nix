{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnomeExtensions.removable-drive-menu
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [ "drive-menu@gnome-shell-extensions.gcampax.github.com" ];
    };
  };
}
