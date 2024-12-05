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
  imports = [ ./module.nix ];

  shell.default = lib.mkDefault "fish";

  programs.fish.enable = true;
  environment.shells = [ fish ];

  home-manager.users.${user} = {
    programs.fish.enable = true;
  };
}
