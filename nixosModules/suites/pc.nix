{
  lib,
  config,
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib2) enabled;
  inherit (lib) types;

  cfg = config.my.suites.pc;
in
{
  options.my.suites.pc = with lib2.options; {
    enable = lib.mkEnableOption "the personal computer suite";
    username = mkOpt' "The username of the single user of the system." types.str;
  };

  config = lib.mkIf cfg.enable {
    my = {
      system = {
        user.name = cfg.username;
        boot = enabled;
        hosts = enabled;
        keys = enabled;
        locale = enabled;
        printing = enabled;
        graphics = enabled;
      };

      desktop = {
        defaultAppsShortcuts = enabled;
        fonts = enabled;
      };

      scripts = {
        nx = enabled;
        terminalUtils = enabled;

        snip = enabled;
        clipboard = enabled;
      };
    };
  };
}
