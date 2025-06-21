{
  pkgs,
  config,
  constants,
  ...
}:

{
  programs.dconf.enable = true;

  ext.packages = with pkgs; [
    gnomeExtensions.rounded-window-corners-reborn
  ];

  home-manager.users.${config.ext.system.user.name} =
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
