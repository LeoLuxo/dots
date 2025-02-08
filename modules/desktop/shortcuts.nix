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
    desktop.keybinds = {
      "Open terminal" = {
        binding = "<Super>grave";
        command = cfg.defaultApps.terminal;
      };

      "Open backup terminal" = {
        binding = "<Super>t";
        command = cfg.defaultApps.backupTerminal;
      };

      "Open web browser" = {
        binding = "<Super>F1";
        command = cfg.defaultApps.browser;
      };

      "Open notes" = {
        binding = "<Super>F2";
        command = cfg.defaultApps.notes;
      };

      "Open code editor" = {
        binding = "<Super>F3";
        command = cfg.defaultApps.codeEditor;
      };

      "Open communication" = {
        binding = "<Super>F4";
        command = cfg.defaultApps.communication;
      };
    };
  };
}
