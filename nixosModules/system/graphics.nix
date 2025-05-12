{
  lib,
  config,
  ...
}:

let
  cfg = config.ext.system.graphics;
in
{
  options.ext.system.graphics = {
    enable = lib.mkEnableOption "graphics";
  };

  config = lib.mkIf cfg.enable {
    # Enable OpenGL
    hardware.graphics = {
      enable = true;
    };
  };
}
