{
  lib,
  config,
  pkgs,
  lib2,
  user,
  ...
}:

let
  inherit (lib) types;
  inherit (lib2) enabled;
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
    my.suites.pc =
      {
        enable = true;
      }
      // {
        username = cfg.username;
      };
  };
}
