{
  pkgs,
  extraLib,
  ...
}:

let
  inherit (extraLib) writeScriptWithDeps;
in

{

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

  my.desktop.keybinds = {
    "Instant screenshot" = {
      binding = "<Super>s";
      command = "snip";
    };
  };
}
