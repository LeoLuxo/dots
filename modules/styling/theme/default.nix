{
  config,
  lib,
  ...
}:
let
  inherit (lib) options types modules;
in

let
  cfg = config.styling.theme;
in
{
  imports = [ ./catppuccin.nix ];

  options.styling.theme = {
    enable = options.mkOption {
      type = types.bool;
      default = cfg.name != null;
    };

    name = options.mkOption {
      type = types.nullOr types.str;
      default = null;
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
