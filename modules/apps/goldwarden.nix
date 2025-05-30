{
  extraLib,
  ...
}:
let
  inherit (extraLib) mkGlobalKeybind;
in
{
  imports = [
    (mkGlobalKeybind {
      name = "Goldwarden";
      binding = "<Super>u";
      command = "dbus-send --type=method_call --dest=com.quexten.Goldwarden.autofill /com/quexten/Goldwarden com.quexten.Goldwarden.Autofill.autofill";
    })
  ];

  programs.goldwarden = {
    enable = true;
  };
}
