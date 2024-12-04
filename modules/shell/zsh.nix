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

  environment.shells = [ zsh ];

  users.users.${user}.shell = zsh;

  # home-manager.users.${user} = {
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
  # };
}
