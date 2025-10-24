{
  pkgs,
  config,

  user,
  ...
}:

{
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    gnomeExtensions.wallhub
  ];

  home-manager.users.${user} =
    { lib, ... }:
    {

      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "wallhub@sakithb.github.io" ];
        };
      };
    };
}
