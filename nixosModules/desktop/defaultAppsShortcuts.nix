{
  lib,
  config,
  ...
}:

let
  cfg = config.my.desktop.defaultAppsShortcuts;
in
{
  options.my.desktop.defaultAppsShortcuts = {
    enable = lib.mkEnableOption "the default apps shortcuts";
  };

  config.my.keybinds = lib.mkIf cfg.enable {
    "Open terminal" = {
      binding = "<Super>grave";
      command = config.my.defaultApps.terminal;
    };

    "Open backup terminal" = {
      binding = "<Super>t";
      command = config.my.defaultApps.backupTerminal;
    };

    "Open web browser" = {
      binding = "<Super>F1";
      command = config.my.defaultApps.browser;
    };

    "Open notes" = {
      binding = "<Super>F2";
      command = config.my.defaultApps.notes;
    };

    "Open code editor" = {
      binding = "<Super>F3";
      command = config.my.defaultApps.codeEditor;
    };

    "Open communication" = {
      binding = "<Super>F4";
      command = config.my.defaultApps.communication;
    };
  };
}
