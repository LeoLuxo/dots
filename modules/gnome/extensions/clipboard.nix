{
  pkgs,
  user,
  lib,
  ...
}:

with lib;

{
  environment.systemPackages = with pkgs; [
    # Manage wallpapers with ease
    gnomeExtensions.clipboard-indicator
  ];

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;

    {
      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "clipboard-indicator@tudmotu.com" ];
        };

        "org/gnome/shell/extensions/clipboard-indicator" = {
          cache-size = 50;
          clear-on-boot = true;
          confirm-clear = true;
          display-mode = 2;
          history-size = 50;
          move-item-first = false;
          paste-button = true;
          pinned-on-bottom = true;
          preview-size = 50;

          toggle-menu = [ "<Super>v" ];
          prev-entry = [ "<Super>comma" ];
          next-entry = [ "<Super>period" ];
        };

      };
    };
}
