{
  pkgs,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  programs.dconf.enable = true;

  ext.packages = with pkgs; [
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
          refresh-button-on = true;
          show-battery-value-on = true;
        };
      };
    };
}
