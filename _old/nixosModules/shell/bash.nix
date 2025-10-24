{
  pkgs,
  config,
  lib,

  user,
  ...
}:

{
  imports = [ ./module.nix ];

  shell.default = lib.mkDefault "bash";

  environment.shells = [ pkgs.bash ];

  home-manager.users.${user} = {
    # Let home manager manage bash; needed to set sessionVariables
    programs.bash = {
      enable = true;
    };
  };
}
