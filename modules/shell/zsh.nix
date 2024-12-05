{
  user,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs) zsh;
in
{
  # imports = [ ./default.nix ];

  # shell.defaultShell = lib.mkDefault "zsh";

  # programs.zsh.enable = true;
  # environment.shells = [ zsh ];

  # home-manager.users.${user} = {
  #   programs.zsh = {
  #     enable = true;

  #     enableCompletion = true;
  #     autosuggestion.enable = true;
  #     syntaxHighlighting.enable = true;

  #     history = {
  #       size = 10000;
  #       ignoreAllDups = true;
  #     };
  #   };
  # };
}
