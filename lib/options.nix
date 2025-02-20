{ lib, ... }:
let
  inherit (lib) types;
in

rec {

  mkEnableOpt = lib.modules.mkEnableOption;

  /**
    Creates a Nix option with specified type, default value and description.
    A convenience wrapper around mkOption to reduce boilerplate.

    # Example

    ```nix
    mkOpt types.str "hello" "A greeting message"
    =>
    {
      type = types.str;
      default = "hello";
      description = "A greeting message";
    }
    ```

    # Type

    ```
    mkOpt :: Type -> a -> String -> Option
    ```

    # Arguments

    type
    : The type for the option (e.g. types.str, types.int)

    default
    : The default value for the option

    description
    : A string describing the purpose of the option
  */
  mkOpt =
    type: default: description:
    lib.mkOption { inherit type default description; };

  /**
    Creates a Nix option with specified type and description.
    A convenience wrapper around mkOption to reduce boilerplate.

    # Example

    ```nix
    mkOpt' types.str "The greeting message"
    =>
    { type = types.str; description = "The greeting message"; }
    ```

    # Type

    ```
    mkOpt' :: Type -> String -> Option
    ```

    # Arguments

    type
    : The type for the option (e.g. types.str, types.int)

    description
    : A string describing the purpose of the option
  */
  mkOpt' = type: description: lib.mkOption { inherit type description; };

  /**
    Creates an option type that can be either null or a specified type.
    Defaults to null.

    # Example

    ```nix
    mkNullOr types.str "An optional string"
    =>
    Option<string | null>
    ```

    # Type

    ```
    mkNullOr :: Type -> String -> Option
    ```

    # Arguments

    type
    : The Nix type to make nullable

    description
    : Documentation string for the option
  */
  mkNullOr = type: description: mkOpt (types.nullOr type) null description;

  /**
    Shorthand for enabling an option.

    # Example

    ```nix
    enabled
    =>
    { enable = true; }
    ```

    # Type

    ```
    enabled :: { enable: Bool }
    ```
  */
  enabled = {
    enable = true;
  };

  /**
    Shorthand for disabling an option.

    # Example

    ```nix
    disabled
    =>
    { enable = false; }
    ```

    # Type

    ```
    disabled :: { enable: Bool }
    ```
  */
  disabled = {
    enable = false;
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
        inherit opts;
      };
      default = { };
      inherit description;
    };

  mkSubmoduleNull =
    description: opts:
    lib.mkOption {
      type = types.nullOr (
        types.submodule {
          inherit opts;
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
    description: opts:
    lib.mkOption {
      type = types.attrsOf (
        types.submodule {
          inherit opts;
        }
      );
      default = { };
      inherit description;
    };
}
