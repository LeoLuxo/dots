{
  pkgs,
  constants,
  cfg,
  lib,
  ...
}:

let
  inherit (lib) modules lists;
in

{
  config = modules.mkIf (cfg.enable && lists.elem "bluetoothQuickConnect" cfg.extensions) {
    programs.dconf.enable = true;

    home-manager.users.${constants.user} =
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
