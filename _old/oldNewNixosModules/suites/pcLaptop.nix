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
      suites.pc =
        {
          enable = true;
        }
        // {
          username = cfg.username;
        };

      system.wifi =
        {
          enable = true;
        }
        // {
          enabledNetworks = [
            "Home"
            "Isabella"
            "Parents"
            "AU Eduroam"
            "Michi"
            "Nadja"
          ];
        };
    };
  };
}
