{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.my.scripts.clipboard;
in
{
  options.my.scripts.clipboard = {
    enable = lib.mkEnableOption "clipboard script";
  };

  config = lib.mkIf cfg.enable {
    my = {
      # wl-clipboard only works under wayland, dunno how to make this config work under X11
      shell.aliases = {
        "copy" = "wl-copy";
        "paste" = "wl-paste";
      };

      packages = [
        pkgs.wl-clipboard
      ];
    };
  };
}
