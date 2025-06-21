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

  cfg = config.my.suites.pc.laptop;
in
{
  options.my.suites.pc.laptop = with lib2.options; {
    enable = lib.mkEnableOption "the laptop computer suite";
    username = mkOpt' "The username of the single user of the system." types.str;
  };

  config = lib.mkIf cfg.enable {
    my = {
      suites.pc = enabled // {
        username = cfg.username;
      };

      wifi = enabled // {
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
