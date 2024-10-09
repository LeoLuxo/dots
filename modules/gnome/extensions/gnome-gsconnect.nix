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

    # KDE Connect implementation for Gnome Shell.
    gnomeExtensions.gsconnect
  ];

  programs.kdeconnect = {
    enable = true;
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
