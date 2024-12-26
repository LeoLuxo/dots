{
  extra-libs,
  lib,
  ...
}:
let
  inherit (extra-libs)
    mkString
    mkBoolDefaultTrue
    mkSubmodule
    mkBoolDefaultFalse
    ;
  inherit (lib) options types;
in
{
  options.desktop = {
    name = mkString;

    power = mkSubmodule {
      button-action = options.mkOption {
        type = types.enum [
          "power off"
          "suspend"
          "hibernate"
          "nothing"
        ];
        default = "power off";
      };

      confirm-shutdown = mkBoolDefaultTrue;

      screen-idle = mkSubmodule {
        enable = mkBoolDefaultTrue;

        delay = options.mkOption {
          type = types.ints.unsigned;
          default = 300;
        };
      };

      suspend-idle = mkSubmodule {
        enable = mkBoolDefaultFalse;

        delay = options.mkOption {
          type = types.ints.unsigned;
          default = 1800;
        };
      };
    };
  };

}
