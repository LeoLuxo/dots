{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnomeExtensions.bluetooth-quick-connect
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [ "bluetooth-quick-connect@bjarosze.gmail.com" ];
    };

    "org/gnome/shell/extensions/bluetooth-quick-connect" = {
      refresh-button-on = false;
      show-battery-value-on = true;
    };
  };
}
