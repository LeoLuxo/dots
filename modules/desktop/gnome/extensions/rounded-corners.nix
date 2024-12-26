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

  home-manager.users.${user} =
    { lib, ... }:
    {
      home.packages = with pkgs; [
        gnomeExtensions.rounded-window-corners-reborn
      ];

      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "rounded-window-corners@fxgn" ];
        };

        "org/gnome/shell/extensions/rounded-window-corners-reborn" = {
          skip-libadwaita-app = false;
          enable-preferences-entry = false;
          black-list = [ "com.github.amezin.ddterm" ];
        };
      };
    };
}
