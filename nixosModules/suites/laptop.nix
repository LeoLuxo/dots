{
  lib,
  config,
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib2) enabled;

  cfg = config.ext.suites.laptop;
in
{
  options.ext.suites.laptop = {
    enable = lib.mkEnableOption "the laptop computer suite";
  };

  config = lib.mkIf cfg.enable {
    ext = {
      suites = {
        pc = enabled;
      };

      wifi = {
        enable = true;
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
