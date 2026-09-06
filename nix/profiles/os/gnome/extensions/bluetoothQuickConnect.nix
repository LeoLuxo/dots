{
  pkgs,
  config,

  user,
  ...
}:

# TODO: Remove in favor of https://extensions.gnome.org/extension/6670/bluetooth-battery-meter/
{
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    gnomeExtensions.bluetooth-quick-connect
  ];

  home-manager.users.${user} =
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
