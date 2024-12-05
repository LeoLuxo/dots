{
  user,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs) fish;
in
{
  # imports = [ ./default.nix ];

  # shell.defaultShell = lib.mkDefault "fish";

  # programs.fish.enable = true;
  # environment.shells = [ fish ];

  # home-manager.users.${user} = {
  #   programs.fish.enable = true;
  # };
}
