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

    # Emoji copy is a versatile extension designed to simplify emoji selection and clipboard management.
    gnomeExtensions.emoji-copy
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
