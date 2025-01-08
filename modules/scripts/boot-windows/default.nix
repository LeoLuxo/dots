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
    }
  );
in
{
  imports = [
    (mkDesktopItem {
      # inherit package;

      name = "boot-windows";
      desktopName = "Boot into Windows";
      exec = lib.traceValSeq "${package}";
      icon = "${directories.images.windows7}";
      # categories = [
      #   "Network"
      #   "FileTransfer"
      #   "P2P"
      # ];
    })
  ];

  home-manager.users.${user} = {
    home.packages = [
      package
    ];
  };

}
