{
  extra-libs,
  ...
}:
let
  inherit (extra-libs) mkGlobalKeybind;
in
{
  imports = [
    (mkGlobalKeybind {
      name = "Open web browser";
      binding = "<Super>F1";
      command = ''xdg-open "http://about:home"'';
    })

    (mkGlobalKeybind {
      name = "Open obsidian";
      binding = "<Super>F2";
      command = ''obsidian'';
    })

    (mkGlobalKeybind {
      name = "Open vscode";
      binding = "<Super>F3";
      command = ''code'';
    })

    (mkGlobalKeybind {
      name = "Open discord";
      binding = "<Super>F4";
      command = ''discord'';
    })

    (mkGlobalKeybind {
      name = "Open steam";
      binding = "<Super>F5";
      command = ''steam'';
    })
  ];
}
