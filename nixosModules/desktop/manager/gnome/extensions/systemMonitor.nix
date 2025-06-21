{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.my.desktop.gnome.extensions.systemMonitor;
in

{
  options.my.desktop.gnome.extensions.systemMonitor = {
    enable = lib.mkEnableOption "the system monitor GNOME extension";
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;

    my.hm =
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
