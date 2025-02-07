{
  lib,
  pkgs,
}:

let
  inherit (lib) types options;
in

{
  # mkNullOr =
  #   type:
  #   options.mkOption {
  #     type = types.nullOr type;
  #     default = null;
  #   };

  # # Options shortcut for a string option
  # mkEmptyString = options.mkOption {
  #   type = types.str;
  #   default = "";
  # };

  # # Options shortcut for a lines option
  # mkEmptyLines = options.mkOption {
  #   type = types.lines;
  #   default = "";
  # };

  # # Options shortcut for a boolean option with default of false
  # mkBoolDefaultFalse = options.mkOption {
  #   type = types.bool;
  #   default = false;
  # };

  # # Options shortcut for a boolean option with default of true
  # mkBoolDefaultTrue = options.mkOption {
  #   type = types.bool;
  #   default = true;
  # };

  mkEnable = options.mkOption {
    type = types.bool;
    default = false;
    example = true;
  };

  # Options shortcut for a submodule
  mkSubmodule =
    opts:
    opts.mkOption {
      type = types.submodule {
        inherit options;
      };
      default = { };
    };

  mkAttrsOfSubmodule =
    opts:
    opts.mkOption {
      type = types.attrsOf (
        types.submodule {
          inherit options;
        }
      );
      default = { };
    };
}
