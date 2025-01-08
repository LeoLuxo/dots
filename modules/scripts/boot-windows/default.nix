{
  pkgs,
  constants,
  extra-libs,
  directories,
  lib,
  ...
}:

let
  inherit (constants) user;
  inherit (extra-libs) mkDesktopItem writeScriptWithDeps;
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
      elevate = true;
    }
  );
in
{
  imports = [
    (mkDesktopItem {
      name = "boot-windows";
      desktopName = "Boot into Windows";
      exec = "${package}/bin/boot-windows";
      icon = "${directories.images.windows7}";
    })
  ];

  home-manager.users.${user} = {
    home.packages = [
      package
    ];
  };

}
