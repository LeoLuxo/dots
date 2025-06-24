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

  # Merges a list of top-level config keys, while avoiding infinite recursion problems
  # Courtesy of https://gist.github.com/udf/4d9301bdc02ab38439fd64fbda06ea43
  mkMergeTopLevel =
    names: attrs:
    lib.getAttrs names (
      lib.mapAttrs (k: v: lib.mkMerge v) (lib.foldAttrs (n: a: [ n ] ++ a) [ ] attrs)
    );
}
