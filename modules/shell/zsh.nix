{
  user,
  pkgs,
  ...
}:
let
  inherit (pkgs) zsh;
in
{
  environment.shells = [ zsh ];

  programs.zsh.enable = true;
  users.users.${user}.shell = zsh;

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
