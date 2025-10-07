{
  pkgs,
  config,
  user,
  lib,

  ...
}:

{
  imports = [ ./module.nix ];

  shell.default = lib.mkDefault "zsh";

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  hm = {
    programs.zsh = {
      enable = true;

      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        size = 10000;
        ignoreAllDups = true;
      };
    };
  };
}
