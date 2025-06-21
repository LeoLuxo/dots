{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.my.desktop.gnome.extensions.emojiCopy;
in

{
  options.my.desktop.gnome.extensions.emojiCopy = {
    enable = lib.mkEnableOption "the emoji copy GNOME extension";
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;

    my.hm =
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
