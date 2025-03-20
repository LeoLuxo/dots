{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.ext.system.touchscreen;
in
{
  options.ext.system.touchscreen = {
    enable = lib.mkEnableOption "touchscreen support";
  };

  config = lib.mkIf cfg.enable {
    # Enable and configure the X11 windowing system.
    services.xserver = {
      enable = true;

      # Touchscreen support
      modules = [ pkgs.xf86_input_wacom ];
      wacom.enable = true;
    };

    # Also for touchscreen support (or maybe touchpad? unsure)
    services.libinput.enable = true;
  };
}
