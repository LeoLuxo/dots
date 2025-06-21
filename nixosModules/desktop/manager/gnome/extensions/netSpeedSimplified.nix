{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.my.desktop.gnome.extensions.netSpeedSimplified;
in

{
  options.my.desktop.gnome.extensions.netSpeedSimplified = {
    enable = lib.mkEnableOption "the net speed simplified GNOME extension";
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;

    my.hm =
      { lib, ... }:
      {
        home.packages = with pkgs; [
          gnomeExtensions.net-speed-simplified
        ];

        dconf.settings = {
          "org/gnome/shell" = {
            enabled-extensions = [ "netspeedsimplified@prateekmedia.extension" ];
          };

          # "org/gnome/shell/extensions/netspeedsimplified" = {
          # };
        };
      };
  };
}
