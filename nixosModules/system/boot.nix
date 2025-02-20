{
  lib,
  config,
  ...
}:

let
  cfg = config.ext.boot;
in
{
  imports = [

  ];

  options.ext.boot = {
    enable = lib.mkEnableOption "bootloading";
  };

  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
