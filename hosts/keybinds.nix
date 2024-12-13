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
  imports = with directories.modules; [
    default-programs

    (mkGlobalKeybind {
      name = "Open web browser";
      binding = "<Super>F1";
      command = config.defaultPrograms.browser;
    })

    (mkGlobalKeybind {
      name = "Open notes";
      binding = "<Super>F2";
      command = config.defaultPrograms.notes;
    })

    (mkGlobalKeybind {
      name = "Open code editor";
      binding = "<Super>F3";
      command = config.defaultPrograms.codeEditor;
    })

    (mkGlobalKeybind {
      name = "Open communication";
      binding = "<Super>F4";
      command = config.defaultPrograms.communication;
    })
  ];
}
