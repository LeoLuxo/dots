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

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;

    {
      dconf.settings = {
        "org/gnome/shell" = {
          # enabled-extensions = [ "clipboard-indicator@tudmotu.com" ];
        };
      };
    };
}
