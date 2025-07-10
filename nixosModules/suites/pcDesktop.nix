{
  lib,
  config,
  ...
}:

let
  inherit (lib) types;
  inherit (lib.my) enabled;
  inherit (lib.options) mkOption;

  cfg = config.my.suites.pc.desktop;
in
{
  options.my.suites.pc.desktop = {
    enable = lib.mkEnableOption "the desktop computer suite";

    username = mkOption {
      description = "The username of the single user of the system.";
      type = types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    my.suites.pc = enabled // {
      username = cfg.username;
    };
  };
}
