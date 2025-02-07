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
  config = modules.mkIf (cfg.enable && lists.elem "systemMonitor" cfg.extensions) {
    programs.dconf.enable = true;

    home-manager.users.${constants.user} =
      { lib, ... }:
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
  };
}
