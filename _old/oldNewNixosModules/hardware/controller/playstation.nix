{
  lib,
  config,
  user,
  ...
}:

let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.my.hardware.controller.playstation;
in

{
  options.my.hardware.controller.playstation = {
    enable = mkEnableOption "PlayStation controller compatibility";
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [
      "hid_sony"
      "hid_playstation"
    ];
  };
}
