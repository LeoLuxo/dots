{
  lib,
  config,
  ...
}:

let
  cfg = config.my.system.graphics;
in
{
  options.my.system.graphics = {
    enable = lib.mkEnableOption "graphics";
  };

  config = lib.mkIf cfg.enable {
    # Enable OpenGL
    hardware.graphics = {
      enable = true;
    };
  };
}
