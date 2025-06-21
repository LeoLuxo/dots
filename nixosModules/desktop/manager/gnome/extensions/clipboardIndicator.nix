{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.my.desktop.gnome.extensions.clipboardIndicator;
in

{
  options.my.desktop.gnome.extensions.clipboardIndicator = {
    enable = lib.mkEnableOption "the clipboard indicator GNOME extension";
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;

    my.hm =
      { lib, ... }:
      {
        home.packages = with pkgs; [
          gnomeExtensions.clipboard-indicator
        ];

        dconf.settings = {
          "org/gnome/shell" = {
            enabled-extensions = [ "clipboard-indicator@tudmotu.com" ];
          };

          "org/gnome/shell/extensions/clipboard-indicator" = {
            cache-size = 50;
            clear-on-boot = true;
            confirm-clear = true;
            display-mode = 2;
            history-size = 50;
            move-item-first = false;
            paste-button = true;
            pinned-on-bottom = true;
            preview-size = 50;

            toggle-menu = [ "<Super>v" ];
            prev-entry = [ "<Super>comma" ];
            next-entry = [ "<Super>period" ];
          };

        };
      };
  };
}
