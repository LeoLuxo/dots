{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.my.desktop.gnome.extensions.wallhub;
in

{
  options.my.desktop.gnome.extensions.wallhub = {
    enable = lib.mkEnableOption "the wallhub GNOME extension";
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;

    my.hm =
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
