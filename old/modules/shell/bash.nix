{
  pkgs,
  config,
  lib,

  ...
}:

{
  imports = [ ./module.nix ];

  shell.default = lib.mkDefault "bash";

  environment.shells = [ pkgs.bash ];

  home-manager.users.${config.my.user.name} = {
    # Let home manager manage bash; needed to set sessionVariables
    programs.bash = {
      enable = true;
    };
  };
}
