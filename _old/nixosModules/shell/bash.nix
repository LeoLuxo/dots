{
  pkgs,
  lib,
  user,
  ...
}:

{
  users.users.${user}.shell = lib.mkDefault pkgs.bash;

  environment.shells = [ pkgs.bash ];

  home-manager.users.${user} = {
    # Let home manager manage bash; needed to set sessionVariables
    programs.bash = {
      enable = true;
    };
  };
}
