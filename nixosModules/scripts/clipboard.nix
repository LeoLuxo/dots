{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.ext.scripts.clipboard;
in
{
  options.ext.scripts.clipboard = {
    enable = lib.mkEnableOption "clipboard script";
  };

  config = lib.mkIf cfg.enable {
    ext = {
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
