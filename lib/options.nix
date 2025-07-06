{ lib, ... }:
let
  inherit (lib) types;
in

{
  enabled = {
    enable = true;
  };

  disabled = {
    enable = false;
  };

  mkSubmodule =
    description: opts:
    lib.mkOption {
      type = types.submodule {
        options = opts;
      };
      inherit description;
    };

  mkAttrs =
    args:
    lib.mkOption (
      {
        type = types.attrsOf (
          types.submodule {
            inherit (args) options;
          }
        );
      }
      // (lib.removeAttrs args [ "options" ])
    );

  mkAttrs' =
    description: opts:
    lib.mkOption {
      type = types.attrsOf (
        types.submodule {
          options = opts;
        }
      );
      default = { };
      inherit description;
    };
}
