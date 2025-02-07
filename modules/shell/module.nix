{
  pkgs,
  lib,
  config,
  constants,
  ...
}:

let
  inherit (constants) user;
  inherit (lib) options types;
in

{
  options.shell = {
    default = options.mkOption {
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
