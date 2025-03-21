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

  cfg = config.ext.suites.desktop;
in
{
  options.ext.suites.desktop = with lib2.options; {
    enable = lib.mkEnableOption "the desktop computer suite";
    username = mkOpt' "The username of the single user of the system." types.str;
  };

  config = lib.mkIf cfg.enable {
    ext.suites.pc = enabled // {
      username = cfg.username;
    };
  };
}
