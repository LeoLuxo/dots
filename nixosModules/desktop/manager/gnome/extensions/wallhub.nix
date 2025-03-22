{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.ext.desktop.gnome.extensions.wallhub;
in

{
  options.ext.desktop.gnome.extensions.wallhub = {
    enable = lib.mkEnableOption "the wallhub GNOME extension";
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;

    ext.hm =
      { lib, ... }:
      {
        home.packages = with pkgs; [
          gnomeExtensions.wallhub
        ];

        dconf.settings = {
          "org/gnome/shell" = {
            enabled-extensions = [ "wallhub@sakithb.github.io" ];
          };
        };
      };
  };
}
