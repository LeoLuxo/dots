{
  pkgs,
  config,
  constants,
  ...
}:

{
  programs.dconf.enable = true;

  ext.packages = with pkgs; [
    gnomeExtensions.emoji-copy
  ];

  home-manager.users.${config.ext.system.user.name} =
    { lib, ... }:
    {
      dconf.settings = {
        "org/gnome/shell" = {
          # enabled-extensions = [ "clipboard-indicator@tudmotu.com" ];
        };
      };
    };
}
