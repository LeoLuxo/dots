{
  user,
  pkgs,
  ...
}:
let
  inherit (pkgs) zsh;
in
{
  imports = [ ./bash.nix ];

  users.defaultUserShell = zsh;
  environment.shells = [ zsh ];

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
}
