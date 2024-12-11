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

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;
    {
      home.packages = with pkgs; [
        gnomeExtensions.system-monitor
      ];

      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "system-monitor@gnome-shell-extensions.gcampax.github.com" ];
        };

        "org/gnome/shell/extensions/system-monitor" = {
          show-cpu = true;
          show-memory = true;
          show-swap = false;
          show-upload = true;
          show-download = true;
        };
      };
    };
}
