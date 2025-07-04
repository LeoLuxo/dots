{
  pkgs,
  config,
  extraLib,
  ...
}:

let
  inherit (extraLib) mkDesktopItem writeScriptWithDeps;
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
  imports = [
    (mkDesktopItem {
      desktopName = "Boot into Windows";
      icon = "${./windows7.png}";
      elevate = true;

      inherit package;
    })
  ];

  my.packages = [
    package
  ];
}
