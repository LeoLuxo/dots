{
  lib,
  config,
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib) types;

  cfg = config.ext.system.keyboard;
in
{
  options.ext.system.keyboard =
    with lib2.options;
    mkSubmoduleNull "the options for keyboard layout configuration" {
      layout = mkOpt' "the layout of the keyboard" types.str;
      variant = mkOpt' "the layout variant" types.str;
    };

  config = lib.mkIf (cfg != null) {
    # Enable and configure the X11 windowing system.
    services.xserver = {
      enable = true;

      # Configure keymap in X11
      xkb = {
        inherit (cfg) layout variant;
      };
    };

  };
}
