{
  pkgs,
  constants,
  directories,
  ...
}:

let
  inherit (constants) user;
in

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [

      (directories.scriptBin."boot-windows" {
        deps = [
          # To query and change the boot order 
          efibootmgr
        ];
      })
    ];
  };

}
