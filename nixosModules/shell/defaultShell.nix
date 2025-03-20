{
  lib,
  config,
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;

  cfg = config.ext.shell.defaultShell;
in
{
  options.ext.shell.defaultShell =
    with lib2.options;
    mkEnum "Which shell to set as default" [
      "bash"
      "zsh"
      "fish"
      "nushell"
      "xonsh"
    ] "bash";

  config = lib.mkIf (config.ext.system.user != null) {
    users.users.${config.ext.system.user.name}.shell = cfg;
  };
}
