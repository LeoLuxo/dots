{
  pkgs,
  config,
  constants,
  ...
}:

{
  programs.dconf.enable = true;

  my.packages = with pkgs; [
    gnomeExtensions.bluetooth-quick-connect
  ];

  home-manager.users.${config.my.user.name} =
    { lib, ... }:
    {

      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "bluetooth-quick-connect@bjarosze.gmail.com" ];
        };

        "org/gnome/shell/extensions/bluetooth-quick-connect" = {
          refresh-button-on = false;
          show-battery-value-on = true;
        };
      };
    };
}
