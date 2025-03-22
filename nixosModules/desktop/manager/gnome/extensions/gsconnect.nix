{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.ext.desktop.gnome.extensions.gsconnect;
in

{
  options.ext.desktop.gnome.extensions.gsconnect = {
    enable = lib.mkEnableOption "the gsconnect GNOME extension";
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;

    programs.kdeconnect = {
      enable = true;
      # KDE Connect implementation for Gnome Shell.
      package = pkgs.gnomeExtensions.gsconnect;
    };

    ext.hm =
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
