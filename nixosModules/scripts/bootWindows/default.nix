{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.ext.scripts.bootWindows;
in
{
  options.ext.scripts.bootWindows = {
    enable = lib.mkEnableOption "the bootWindows script";
  };

  config = lib.mkIf cfg.enable (
    let
      package = (
        pkgs.writeScriptWithDeps {
          name = "bootWindows";
          file = ./bootWindows.sh;
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
