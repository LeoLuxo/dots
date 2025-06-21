{
  pkgs,
  config,
  constants,
  ...
}:

{
  programs.dconf.enable = true;

  ext.packages = with pkgs; [
    gnomeExtensions.wallhub
  ];

  home-manager.users.${config.ext.system.user.name} =
    { lib, ... }:
    {

      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "wallhub@sakithb.github.io" ];
        };
      };
    };
}
