{
  pkgs,
  lib,
  lib2,
  ...
}:

{
  environment.systemPackages = [
    (pkgs.writeScriptWithDeps {
      name = "snip";
      file = ./snip.sh;
      deps = [
        pkgs.gnome-screenshot
        pkgs.wl-clipboard
      ];
    })
  ];

  imports = [
    (lib2.nixos.mkKeybind {
      name = "Instant screenshot";
      binding = "<Super>s";
      command = "snip";
    })
  ];
}
