{
  lib,
  config,
  ...
}:

let
  cfg = config.ext.desktop.defaultAppsShortcuts;
in
{
  options.ext.desktop.defaultAppsShortcuts = {
    enable = lib.mkEnableOption "the default apps shortcuts";
  };

  config = lib.mkIf cfg.enable {
    ext.desktop.keybinds = {
      "Open terminal" = {
        binding = "<Super>grave";
        command = config.ext.desktop.defaultApps.terminal;
      };

      "Open backup terminal" = {
        binding = "<Super>t";
        command = config.ext.desktop.defaultApps.backupTerminal;
      };

      "Open web browser" = {
        binding = "<Super>F1";
        command = config.ext.desktop.defaultApps.browser;
      };

      "Open notes" = {
        binding = "<Super>F2";
        command = config.ext.desktop.defaultApps.notes;
      };

      "Open code editor" = {
        binding = "<Super>F3";
        command = config.ext.desktop.defaultApps.codeEditor;
      };

      "Open communication" = {
        binding = "<Super>F4";
        command = config.ext.desktop.defaultApps.communication;
      };
    };
  };
}
