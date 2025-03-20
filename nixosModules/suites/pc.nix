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

  cfg = config.ext.suites.pc;
in
{
  options.ext.suites.pc = {
    enable = lib.mkEnableOption "the personal computer suite";
  };

  config = lib.mkIf cfg.enable {
    ext = {
      system = {
        user.name = specialArgs.user;
        boot = enabled;
        hosts = enabled;
        keys = enabled;
        locale = enabled;
        printing = enabled;
      };

      desktop.defaultAppsShortcuts = enabled;
    };
  };
}
