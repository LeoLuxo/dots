{
  pkgs,
  config,

  user,
  ...
}:

{
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    gnomeExtensions.removable-drive-menu
  ];

  home-manager.users.${user} =
    { lib, ... }:
    {

      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "drive-menu@gnome-shell-extensions.gcampax.github.com" ];
        };
      };
    };
}
