{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib2) enabled;
  inherit (lib) types;

  cfg = config.ext.system.touchscreen;
in
{
  options.ext.system.touchscreen = with lib2.options; {
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
