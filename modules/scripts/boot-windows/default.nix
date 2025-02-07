{
  cfg,
  lib,
  pkgs,
  extraLib,
  constants,
  ...
}:

let
  inherit (lib) modules;
  inherit (extraLib) mkEnable writeScriptWithDeps mkDesktopItem;
in
{
  options = {
    enable = mkEnable;
  };

  config = modules.mkIf cfg.enable {
    home-manager.users.${constants.user} =
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
        home.packages = [
          package

          (mkDesktopItem {
            desktopName = "Boot into Windows";
            icon = "${./windows7.png}";
            elevate = true;

            inherit package;
          })
        ];
      };
  };
}
