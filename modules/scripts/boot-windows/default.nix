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
      inherit package;

      name = "boot-windows";
      # desktopName = "Windows";
      # exec = "firefox";
      icon = "${directories.images.syncthing}";
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
