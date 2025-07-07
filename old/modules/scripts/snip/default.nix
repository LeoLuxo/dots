{
  pkgs,
  extraLib,
  ...
}:

let
  inherit (extraLib) writeScriptWithDeps;
in

{
  my.packages = [
    (writeScriptWithDeps {
      name = "snip";
      file = ./snip.sh;
      deps = [
        pkgs.gnome-screenshot
        pkgs.wl-clipboard
      ];
    })
  ];

  my.keybinds."Instant screenshot" = {
    binding = "<Super>s";
    command = "snip";
  };
}
