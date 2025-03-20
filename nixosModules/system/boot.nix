{
  lib,
  config,
  ...
}:

let
  cfg = config.ext.system.boot;
in
{
  options.ext.system.boot = {
    enable = lib.mkEnableOption "bootloading";
  };

  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
