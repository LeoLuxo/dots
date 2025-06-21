{
  pkgs,
  config,
  lib,
  constants,
  ...
}:

{
  imports = [ ./module.nix ];

  shell.default = lib.mkDefault "zsh";

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  home-manager.users.${config.my.system.user.name} = {
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
