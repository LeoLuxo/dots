{
  pkgs,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  programs.dconf.enable = true;

  home-manager.users.${constants.user} =
    { lib, ... }:
    {
      home.packages = with pkgs; [
        gnomeExtensions.emoji-copy
      ];

      dconf.settings = {
        "org/gnome/shell" = {
          # enabled-extensions = [ "clipboard-indicator@tudmotu.com" ];
        };
      };
    };
}
