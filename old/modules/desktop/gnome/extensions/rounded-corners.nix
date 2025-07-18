{
  pkgs,
  config,
  constants,
  ...
}:

{
  programs.dconf.enable = true;

  my.packages = with pkgs; [
    gnomeExtensions.rounded-window-corners-reborn
  ];

  home-manager.users.${config.my.user.name} =
    { lib, ... }:
    {

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
