{
  config,
  lib,
  pkgs,

  constants,
  ...
}:

let
  inherit (lib) modules;
  inherit (extraLib) mkEnable;
in
{
  options = {
    enable = mkEnable;
  };

  config = modules.mkIf cfg.enable {
    # wl-clipboard only works under wayland, dunno how to make this config work under X11
    shell.aliases = {
      "copy" = "wl-copy";
      "paste" = "wl-paste";
    };

    home-manager.users.${constants.user} = {
      home.packages = [
        pkgs.wl-clipboard
      ];
    };
  };
}
