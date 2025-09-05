{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnomeExtensions.wallhub
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [ "wallhub@sakithb.github.io" ];
    };
  };
}
