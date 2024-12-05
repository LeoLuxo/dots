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
  # imports = [ ./default.nix ];

  # shell.defaultShell = lib.mkDefault "bash";

  # programs.bash.enable = true;
  # environment.shells = [ bash ];

  # home-manager.users.${user} = {
  #   # Let home manager manage bash; needed to set sessionVariables
  #   programs.bash.enable = true;
  # };
}
