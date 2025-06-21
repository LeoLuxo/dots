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

  cfg = config.my.suites.pc.desktop;
in
{
  options.my.suites.pc.desktop = with lib2.options; {
    enable = lib.mkEnableOption "the desktop computer suite";
    username = mkOpt' "The username of the single user of the system." types.str;
  };

  config = lib.mkIf cfg.enable {
    my.suites.pc = enabled // {
      username = cfg.username;
    };
  };
}
