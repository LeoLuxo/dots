{
  config,
  nixosModules,
  ...
}:
{
  imports = [
    nixosModules.defaults
  ];

  config.desktop.keybinds = {
    "Open terminal" = {
      binding = "<Super>grave";
      command = config.defaults.apps.terminal;
    };

    "Open backup terminal" = {
      binding = "<Super>t";
      command = config.defaults.apps.backupTerminal;
    };

    "Open web browser" = {
      binding = "<Super>F1";
      command = config.defaults.apps.browser;
    };

    "Open notes" = {
      binding = "<Super>F2";
      command = config.defaults.apps.notes;
    };

    "Open code editor" = {
      binding = "<Super>F3";
      command = config.defaults.apps.codeEditor;
    };

    "Open communication" = {
      binding = "<Super>F4";
      command = config.defaults.apps.communication;
    };
  };

}
