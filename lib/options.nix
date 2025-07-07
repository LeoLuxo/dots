{ lib, ... }:
let
  inherit (lib) types;
in

rec {
  enabled = {
    enable = true;
  };

  disabled = {
    enable = false;
  };

  mkSubmodule =
    opts:
    lib.mkOption {
      type = types.submodule {
        options = opts;
      };
    };

  mkAttrs =
    { options, ... }@attrArgs:
    lib.mkOption (
      {
        type = types.attrsOf (
          types.submodule (
            { config, ... }@submoduleArgs:
            {
              options =
                if lib.isAttrs options then
                  # the given options field is a simple attrset
                  options
                else
                  # the given options field is (probably) a function expecting the extra args
                  options (
                    submoduleArgs
                    // {
                      name = config._module.args.name;
                    }
                  );
            }
          )
        );
      }
      // (lib.removeAttrs attrArgs [ "options" ])
    );

  mkAttrs' =
    description: options:
    mkAttrs {
      inherit description options;
      default = { };
    };
}
