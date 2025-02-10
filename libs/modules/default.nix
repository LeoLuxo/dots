{
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};

{
  /**
    Creates an option with specified type and default value

    # Type
    ```
    mkOpt :: Type -> a -> Option
    ```

    # Arguments
    type
    : The type of the option

    default
    : The default value

    # Example
    ```nix
    mkOpt types.str "hello"
    =>
    Option of type string with default "hello"
    ```
  */
  mkOpt = type: default: mkOption { inherit type default; };

  /**
    Creates an option with specified type but no default value

    # Type
    ```
    mkOpt' :: Type -> Option
    ```

    # Arguments
    type
    : The type of the option

    # Example
    ```nix
    mkOpt' types.str
    =>
    Option of type string with no default
    ```
  */
  mkOpt' = type: mkOption { inherit type; };

  /**
    Creates a nullable option with a default value of null

    # Type
    ```
    mkNullOr :: Type -> Option
    ```

    # Arguments
    type
    : The type to make nullable

    # Example
    ```nix
    mkNullOr types.str
    =>
    Option of type `null | string` with default null
    ```
  */
  mkNullOr = type: mkOpt (types.nullOr type) null;

  /**
    Creates a boolean enable option defaulting to false

    # Type
    ```
    mkEnable :: Option
    ```

    # Example
    ```nix
    mkEnable
    =>
    Option of type bool with default false
    ```
  */
  mkEnable = mkOption {
    type = types.bool;
    default = false;
    example = true;
  };

  /**
    Shorthand for enable = true

    # Example
    ```nix
    enabled
    =>
    { enable = true; }
    ```
  */
  enabled = {
    enable = true;
  };

  /**
    Shorthand for enable = false

    # Example
    ```nix
    disabled
    =>
    { enable = false; }
    ```
  */
  disabled = {
    enable = false;
  };

  /**
    Creates a submodule option with specified options

    # Type
    ```
    mkSubmodule :: AttrSet -> Option
    ```

    # Arguments
    opts
    : The options to include in the submodule

    # Example
    ```nix
    mkSubmodule { foo = mkOpt types.str "bar"; }
    =>
    Option of type submodule with specified options
    ```
  */
  mkSubmodule =
    opts:
    mkOption {
      type = types.submodule {
        inherit opts;
      };
      default = { };
    };

  /**
    Creates an attribute set of submodules with specified options

    # Type
    ```
    mkAttrsSub :: AttrSet -> Option
    ```

    # Arguments
    opts
    : The options to include in each submodule

    # Example
    ```nix
    mkAttrsSub { foo = mkOpt types.str "bar"; }
    =>
    Option of type attrsOf(submodule) with specified options
    ```
  */
  mkAttrsSub =
    opts:
    mkOption {
      type = types.attrsOf (
        types.submodule {
          inherit opts;
        }
      );
      default = { };
    };
}
