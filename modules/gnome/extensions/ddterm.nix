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
    gnomeExtensions.ddterm
  ];

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;

    {
      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "ddterm@amezin.github.com" ];
        };

        "com/github/amezin/ddterm" = {
          audible-bell = false;
          backspace-binding = "auto";
          cursor-shape = "ibeam";
          custom-font = "Mononoki Nerd Font 14";
          ddterm-toggle-hotkey = [ "<Super>backslash" ];
          delete-binding = "auto";
          hide-when-focus-lost = true;
          hide-window-on-esc = true;
          pointer-autohide = true;
          shortcuts-enabled = false;
          use-system-font = false;
          window-position = "left";
        };

      };
    };
}
