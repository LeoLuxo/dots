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
    gnomeExtensions.system-monitor
  ];

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;

    {
      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "system-monitor@gnome-shell-extensions.gcampax.github.com" ];
        };
      };

      "org/gnome/shell/extensions/system-monitor" = {
        show-cpu = true;
        show-memory = true;
        show-swap = false;
        show-upload = true;
        show-download = true;
      };
    };
}
