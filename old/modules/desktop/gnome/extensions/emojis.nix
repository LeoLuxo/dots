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

  ext.packages = with pkgs; [
    gnomeExtensions.emoji-copy
  ];

  home-manager.users.${user} =
    { lib, ... }:
    {
      dconf.settings = {
        "org/gnome/shell" = {
          # enabled-extensions = [ "clipboard-indicator@tudmotu.com" ];
        };
      };
    };
}
