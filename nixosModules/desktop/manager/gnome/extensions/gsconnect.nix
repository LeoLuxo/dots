{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.my.desktop.gnome.extensions.gsconnect;
in

{
  options.my.desktop.gnome.extensions.gsconnect = {
    enable = lib.mkEnableOption "the gsconnect GNOME extension";
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;

    programs.kdeconnect = {
      enable = true;
      # KDE Connect implementation for Gnome Shell.
      package = pkgs.gnomeExtensions.gsconnect;
    };

    my.hm =
      { lib, ... }:
      {
        dconf.settings = {
          "org/gnome/shell" = {
            enabled-extensions = [ "gsconnect@andyholmes.github.io" ];
          };
        };
      };
  };
}
