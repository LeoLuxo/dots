{ pkgs, ... }:

let
  package = pkgs.writeScriptWithDeps {
    name = "boot-windows";
    file = ./boot-windows.sh;
    deps = [
      # To query and change the boot order
      pkgs.efibootmgr
    ];
  };
in
{
  environment.systemPackages = [
    package

    (pkgs.mkDesktopItem {
      desktopName = "Boot into Windows";
      icon = "${./windows7.png}";
      elevate = true;

      inherit package;
    })
  ];
}
