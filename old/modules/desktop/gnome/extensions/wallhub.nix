{
  pkgs,
  config,
  constants,
  ...
}:

{
  programs.dconf.enable = true;

  my.packages = with pkgs; [
    gnomeExtensions.wallhub
  ];

  home-manager.users.${config.my.user.name} =
    { lib, ... }:
    {

      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "wallhub@sakithb.github.io" ];
        };
      };
    };
}
