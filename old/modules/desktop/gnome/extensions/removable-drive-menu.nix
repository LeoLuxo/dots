{
  pkgs,
  config,

  ...
}:

{
  programs.dconf.enable = true;

  my.packages = with pkgs; [
    gnomeExtensions.removable-drive-menu
  ];

  home-manager.users.${config.my.user.name} =
    { lib, ... }:
    {

      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "drive-menu@gnome-shell-extensions.gcampax.github.com" ];
        };
      };
    };
}
