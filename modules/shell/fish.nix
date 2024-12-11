{
  pkgs,
  lib,
  constants,
  ...
}:

let
  inherit (constants) user;
in
{
  imports = [ ./module.nix ];

  shell.default = lib.mkDefault "fish";

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  home-manager.users.${user} = {
    programs.fish = {
      enable = true;

      shellAliases = {
        last-command = "history --search -n 1";
      };
    };
  };
}
