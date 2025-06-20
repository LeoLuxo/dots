{
  pkgs,
  extraLib,
  ...
}:

let
  inherit (extraLib) mkGlobalKeybind;
in

{
  imports = [
    (mkGlobalKeybind {
      name = "Instant translate";
      binding = "<Super>d";
      command = "dialect --selection";
    })
  ];

  ext.packages = with pkgs; [
    # Gnome circles translator app
    dialect
  ];
}
