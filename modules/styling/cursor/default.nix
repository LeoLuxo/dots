{
  config,
  lib,
  ...
}:
let
  inherit (lib) options types modules;
in

let
  cfg = config.styling.cursor;
in
{
  imports = [ ./catppuccin.nix ];

  options.styling.cursor = {
    enable = options.mkOption {
      type = types.bool;
      default = cfg.name != null;
    };

    name = options.mkOption {
      type = types.nullOr types.str;
      default = null;
    };

    size = options.mkOption {
      type = types.ints.unsigned;
      default = 32;
    };
  };

  config = modules.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.name != null;
        message = "Theme name must be set!";
      }
    ];
  };
}
