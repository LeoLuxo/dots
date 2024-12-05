{
  pkgs,
  user,
  lib,
  config,
  ...
}:

with lib;

{
  options.shell = {
    default = mkOption {
      type = types.enum [
        "bash"
        "zsh"
        "fish"
        "nushell"
        "xonsh"
      ];
      default = "bash";
      description = "Which shell to set as default";
    };
  };

  config = {
    users.users.${user}.shell = pkgs.${config.shell.default};
  };
}
