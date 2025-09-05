{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnomeExtensions.emoji-copy
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      # enabled-extensions = [ "clipboard-indicator@tudmotu.com" ];
    };
  };
}
