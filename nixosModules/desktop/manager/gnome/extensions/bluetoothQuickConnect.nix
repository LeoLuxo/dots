{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.my.desktop.gnome.extensions.bluetoothQuickConnect;
in

{
  options.my.desktop.gnome.extensions.bluetoothQuickConnect = {
    enable = lib.mkEnableOption "the bluetooth quick connect GNOME extension";
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;

    my.hm =
      { lib, ... }:
      {
        home.packages = with pkgs; [
          gnomeExtensions.bluetooth-quick-connect
        ];

        dconf.settings = {
          "org/gnome/shell" = {
            enabled-extensions = [ "bluetooth-quick-connect@bjarosze.gmail.com" ];
          };

          "org/gnome/shell/extensions/bluetooth-quick-connect" = {
            refresh-button-on = true;
            show-battery-value-on = true;
          };
        };
      };
  };
}
