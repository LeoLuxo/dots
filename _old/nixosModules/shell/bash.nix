{
  pkgs,
  config,
  user,
  lib,

  ...
}:

{
  imports = [ ./module.nix ];

  shell.default = lib.mkDefault "bash";

  environment.shells = [ pkgs.bash ];

  hm = {
    # Let home manager manage bash; needed to set sessionVariables
    programs.bash = {
      enable = true;
    };
  };
}
