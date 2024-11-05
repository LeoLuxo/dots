{
  pkgs,
  user,
  scriptBin,
  ...
}:
{
  imports = [ ];
  home-manager.users.${user} = {
    home.packages = [
      (scriptBin.size { })
    ];
  };
}
