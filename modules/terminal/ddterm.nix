{
  cfg,
  lib,
  extraLib,
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
    desktop.gnome.extensions.ddterm.enable = true;
  };
}
