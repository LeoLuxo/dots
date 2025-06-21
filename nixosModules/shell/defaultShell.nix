{
  lib,
  config,
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;

  cfg = config.my.shell.defaultShell;
in
{
  options.my.shell.defaultShell =
    with lib2.options;
    mkEnum "Which shell to set as default" [
      "bash"
      "zsh"
      "fish"
      "nushell"
      "xonsh"
    ] "bash";

  config = lib.mkIf (config.my.system.user != null) {
    users.users.${config.my.system.user.name}.shell = cfg;
  };
}
