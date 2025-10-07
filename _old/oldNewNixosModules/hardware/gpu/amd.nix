{
  lib,
  config,
  user,
  ...
}:

let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.my.hardware.gpu.amd;
in

{
  options.my.hardware.gpu.amd = {
    enable = mkEnableOption "AMD gpu compatibility";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "modesetting" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.amdgpu.initrd.enable = true;
  };
}
