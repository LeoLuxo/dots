{ lib2, ... }:
{
  imports = [
    (lib2.mkGlobalKeybind {
      name = "Open nx-code";
      binding = "<Super>F9";
      command = "nx-code";
    })
  ];
}
