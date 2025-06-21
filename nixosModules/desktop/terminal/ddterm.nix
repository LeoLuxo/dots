{
  lib,
  config,
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib2) enabled;

  cfg = config.my.desktop.terminal.ddterm;
in
{
  options.my.desktop.terminal.ddterm = {
    enable = lib.mkEnableOption "the ddterm terminal";
  };

  config = lib.mkIf cfg.enable {
    my.desktop = {
      manager.gnome.extensions."ddterm" = enabled;

      defaultApps.terminal = lib.mkDefault "gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/ddterm --method com.github.amezin.ddterm.Extension.Toggle";
    };
  };
}
