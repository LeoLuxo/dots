{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnomeExtensions.net-speed-simplified
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [ "netspeedsimplified@prateekmedia.extension" ];
    };

    # "org/gnome/shell/extensions/netspeedsimplified" = {
    # };
  };
}
