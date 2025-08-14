{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) types;
  inherit (pkgs.lib2) enabled;
  inherit (lib.options) mkOption;

  cfg = config.my.suites.pc.laptop;
in
{
  options.my.suites.pc.laptop = {
    enable = lib.mkEnableOption "the laptop computer suite";

    username = mkOption {
      description = "The username of the single user of the system.";
      type = types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    my = {
      suites.pc = enabled // {
        username = cfg.username;
      };

      system.wifi = enabled // {
        enabledNetworks = [
          "Home"
          "Isabella"
          "Parents"
          "AU Eduroam"
          "Philipp"
          "Nadja"
        ];
      };
    };
  };
}
