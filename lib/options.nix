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

  mkOpt =
    description: type: default:
    lib.mkOption { inherit type default description; };

  mkOpt' = description: type: lib.mkOption { inherit type description; };

  mkNullOr = description: type: mkOpt (types.nullOr type) null description;

  mkEnum =
    description: variants: default:
    lib.mkOption {
      type = types.enum variants;
      inherit description default;
    };

  mkEnum' =
    description: variants:
    lib.mkOption {
      type = types.enum variants;
      inherit description;
    };

  /**
    Creates a submodule option with specified options.

    # Example

    ```nix
    mkSubmodule "A submodule" { foo = mkOpt types.str "bar"; }
    =>
    Option of type submodule with specified options
    ```

    # Type

    ```
    mkSubmodule :: String -> AttrSet -> Option
    ```

    # Arguments

    description
    : Documentation string for the submodule option

    opts
    : The options to include in the submodule
  */
  mkSubmodule =
    description: opts:
    lib.mkOption {
      type = types.submodule {
        options = opts;
      };
      default = { };
      inherit description;
    };

  mkSubmoduleNull =
    description: opts:
    lib.mkOption {
      type = types.nullOr (
        types.submodule {
          options = opts;
        }
      );
      default = null;
      inherit description;
    };

  /**
    Creates an attribute set of submodules with specified options.

    # Example

    ```nix
    mkAttrsSub "A set of submodules" { foo = mkOpt types.str "bar"; }
    =>
    Option of type attrsOf(submodule) with specified options
    ```

    # Type

    ```
    mkAttrsSub :: String -> AttrSet -> Option
    ```

    # Arguments

    description
    : Documentation string for the submodules attribute set

    opts
    : The options to include in each submodule
  */
  mkAttrsSub =
    description: opts: default:
    lib.mkOption {
      type = types.attrsOf (
        types.submodule {
          options = opts;
        }
      );
      inherit description default;
    };

  mkAttrsSub' =
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
