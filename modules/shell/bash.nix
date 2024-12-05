{
  user,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs) bash;
in
{
  imports = [ ./module.nix ];

  shell.default = lib.mkDefault "bash";

  environment.shells = [ bash ];

  home-manager.users.${user} = {
    # Let home manager manage bash; needed to set sessionVariables
    programs.bash.enable = true;
  };
}
