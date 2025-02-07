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
    desktop.gnome.extensions = [ "ddterm" ];

    desktop.defaultApps.terminal = lib.mkDefault "gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/ddterm --method com.github.amezin.ddterm.Extension.Toggle";
  };
}
