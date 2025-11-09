{
  pkgs,
  lib,
  user,
  ...
}:

{
  users.users.${user}.shell = lib.mkDefault pkgs.zsh;

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  home-manager.users.${user} = {
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
