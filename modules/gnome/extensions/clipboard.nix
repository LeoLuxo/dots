{
  pkgs,
  user,
  lib,
  ...
}:

with lib;

{
  environment.systemPackages = with pkgs; [
    # Gnome Clipboard History is a clipboard manager GNOME extension that saves items you've copied into an easily accessible, searchable history panel.
    gnomeExtensions.clipboard-history
  ];

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;

    {
      dconf.settings = {
        "org/gnome/shell" = {
          # enabled-extensions = [ ];
        };

        "org/gnome/shell/extensions/clipboard-indicator" = {
          # cache-size = 50;
          # clear-on-boot = true;
          # confirm-clear = true;
          # display-mode = 2;
          # history-size = 50;
          # move-item-first = false;
          # paste-button = true;
          # pinned-on-bottom = true;
          # preview-size = 50;

          # toggle-menu = [ "<Super>v" ];
          # prev-entry = [ "<Super>comma" ];
          # next-entry = [ "<Super>period" ];
        };

      };
    };
}
