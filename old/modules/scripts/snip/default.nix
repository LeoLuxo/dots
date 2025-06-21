{
  pkgs,
  config,
  extraLib,
  ...
}:

let
  inherit (extraLib) mkGlobalKeybind writeScriptWithDeps;
in

{
  imports = [
    (mkGlobalKeybind {
      name = "Instant screenshot";
      binding = "<Super>s";
      command = "snip";
    })
  ];

  my.packages = with pkgs; [
    (writeScriptWithDeps {
      name = "snip";
      file = ./snip.sh;
      deps = [
        gnome-screenshot
        wl-clipboard
      ];
    })
  ];
}
