{
  config,
  extra-libs,
  directories,
  ...
}:
let
  inherit (extra-libs) mkGlobalKeybind;
in
{
  imports = [
    directories.modules.defaults

    (mkGlobalKeybind {
      name = "Open terminal";
      binding = "<Super>grave";
      command = config.defaults.apps.terminal;
    })

    (mkGlobalKeybind {
      name = "Open backup terminal";
      binding = "<Super>t";
      command = config.defaults.apps.backupTerminal;
    })

    (mkGlobalKeybind {
      name = "Open web browser";
      binding = "<Super>F1";
      command = config.defaults.apps.browser;
    })

    (mkGlobalKeybind {
      name = "Open notes";
      binding = "<Super>F2";
      command = config.defaults.apps.notes;
    })

    (mkGlobalKeybind {
      name = "Open code editor";
      binding = "<Super>F3";
      command = config.defaults.apps.codeEditor;
    })

    (mkGlobalKeybind {
      name = "Open communication";
      binding = "<Super>F4";
      command = config.defaults.apps.communication;
    })
  ];
}
