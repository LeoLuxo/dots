{
  pkgs,
  constants,
  extra-libs,
  directories,
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
    }
  );
in
{
  imports = [
    (mkDesktopItem {
      name = "boot-windows";
      desktopName = "Boot into Windows";
      exec = "${package}";
      icon = "${directories.images.syncthing}";
    })
  ];

  home-manager.users.${user} = {
    home.packages = [
      package
    ];
  };

}
