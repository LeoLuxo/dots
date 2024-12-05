{
  pkgs,
  user,
  lib,
  ...
}:

with lib;

{
  # options.shell = {
  #   defaultShell = mkOption {
  #     type = types.enum [
  #       "bash"
  #       "zsh"
  #       "fish"
  #       "nushell"
  #       "xonsh"
  #     ];
  #     default = "bash";
  #     description = "Which shell to set as default";
  #   };
  # };

  # config = {
  #   users.users.${user}.shell = pkgs.${config.shell.default};
  # };
}
