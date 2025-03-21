{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.ext.scripts.boot-windows;
in
{
  options.ext.scripts.boot-windows = {
    enable = lib.mkEnableOption "the boot-windows script";
  };

  config = lib.mkIf cfg.enable (
    let
      package = (
        pkgs.writeScriptWithDeps {
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

      ext.packages = [
        package

        (pkgs.mkDesktopItem {
          desktopName = "Boot into Windows";
          icon = "${./windows7.png}";
          elevate = true;

          inherit package;
        })
      ];

    }
  );
}
