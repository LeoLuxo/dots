{
  pkgs,
  ...
}:

let
  inherit (pkgs.lib2) writeScriptWithDeps mkDesktopItem;
in

let
  package = (
    writeScriptWithDeps {
      name = "boot-windows";
      file = ./boot-windows.sh;
      deps = [
        # To query and change the boot order
        pkgs.efibootmgr
      ];
    }
  );
in
{
  my.packages = [
    package

    (mkDesktopItem {
      desktopName = "Boot into Windows";
      icon = "${./windows7.png}";
      elevate = true;

      inherit package;
    })
  ];
}
