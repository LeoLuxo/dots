{
  pkgs,
  constants,
  directories,
  extra-libs,
  ...
}:

let
  inherit (constants) user;
  inherit (extra-libs) writeScriptWithDeps;
in

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      (writeScriptWithDeps {
        name = "boot-windows";
        file = ./boot-windows.sh;
        deps = [
          # To query and change the boot order 
          efibootmgr
        ];
      })
    ];
  };

}
