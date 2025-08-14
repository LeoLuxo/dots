{
  pkgs,
  config,

  ...
}:

{
  programs.dconf.enable = true;

  programs.kdeconnect = {
    enable = true;
    # KDE Connect implementation for Gnome Shell.
    package = pkgs.gnomeExtensions.gsconnect;
  };

  home-manager.users.${config.my.user.name} =
    { lib, ... }:
    {
      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "gsconnect@andyholmes.github.io" ];
        };
      };
    };
}
