{
  pkgs,
  lib2,
  ...
}:

{
  imports = [
    (lib2.mkGlobalKeybind {
      name = "Instant screenshot";
      binding = "<Super>s";
      command = "snip";
    })
  ];

  home.packages = [
    (pkgs.writeScriptWithDeps {
      name = "snip";
      file = ./snip.sh;
      deps = [
        pkgs.gnome-screenshot
        pkgs.wl-clipboard
      ];
    })
  ];
}
