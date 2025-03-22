{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.ext.desktop.gnome.extensions.emojiCopy;
in

{
  options.ext.desktop.gnome.extensions.emojiCopy = {
    enable = lib.mkEnableOption "the emoji copy GNOME extension";
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;

    ext.hm =
      { lib, ... }:
      {
        home.packages = with pkgs; [
          gnomeExtensions.emoji-copy
        ];

        dconf.settings = {
          "org/gnome/shell" = {
            # enabled-extensions = [ "clipboard-indicator@tudmotu.com" ];
          };
        };
      };
  };
}
