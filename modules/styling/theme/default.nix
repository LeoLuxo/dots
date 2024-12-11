{
  config,
  lib,
  extra-libs,
  ...
}:
let
  inherit (lib) options types modules;
  inherit (extra-libs) mkBoolDefaultFalse;
in

let
  cfg = config.styling.theme;
in
{
  imports = [ ./catppuccin.nix ];

  options.styling.theme = {
    enable = mkBoolDefaultFalse;

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
