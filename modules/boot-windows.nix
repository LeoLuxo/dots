{
  pkgs,
  user,
  scriptBin,
  ...
}:
{
  home-manager.users.${user} = {
    home.packages = with pkgs; [

      (scriptBin.boot-windows {
        deps = [
          # To query and change the boot order 
          efibootmgr
        ];
      })
    ];
  };

}
