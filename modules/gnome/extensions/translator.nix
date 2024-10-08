{
  pkgs,
  user,
  lib,
  ...
}:

with lib;

{
  environment.systemPackages = with pkgs; [
    # Translate extension for Gnome-Shell - based on translate-shell, inspired by Tudmotu's clipboard-indicator and gufoe's text-translator.
    gnomeExtensions.translate-clipboard
  ];

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;

    {
      dconf.settings = {
        "org/gnome/shell" = {
          # enabled-extensions = [ "clipboard-indicator@tudmotu.com" ];
        };

        "org/gnome/shell/extensions/translate-clipboard" =
          {
          };

      };
    };
}
