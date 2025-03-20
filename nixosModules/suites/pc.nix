{
  lib,
  config,
  inputs,
  specialArgs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib2) enabled;
  inherit (lib) types;

  cfg = config.ext.suites.pc;
in
{
  options.ext.suites.pc = with lib2.options; {
    enable = lib.mkEnableOption "the personal computer suite";
  };

  config = lib.mkIf cfg.enable {
    ext = {
      user.name = specialArgs.user;

      base = enabled;
      boot = enabled;
      hosts = enabled;
      keys = enabled;
      locale = enabled;
    };
  };
}
