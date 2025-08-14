{
  pkgs,
  config,

  ...
}:

{
  programs.dconf.enable = true;

  my.packages = with pkgs; [
    gnomeExtensions.emoji-copy
  ];

  home-manager.users.${config.my.user.name} =
    { lib, ... }:
    {
      dconf.settings = {
        "org/gnome/shell" = {
          # enabled-extensions = [ "clipboard-indicator@tudmotu.com" ];
        };
      };
    };
}
