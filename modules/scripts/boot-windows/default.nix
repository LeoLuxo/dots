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
      # inherit package;

      name = "boot-windows";
      desktopName = "Boot into Windows";
      exec = "boot-windows";
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
