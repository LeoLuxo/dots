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

  mkOptDefault =
    description: type: default:
    lib.mkOption { inherit type default description; };

  mkOpt = description: type: lib.mkOption { inherit type description; };

  mkNullOr = description: type: mkOptDefault (types.nullOr type) null description;

  mkEnumDefault =
    description: variants: default:
    lib.mkOption {
      type = types.enum variants;
      inherit description default;
    };

  mkEnum =
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

  mkAttrsSubDefault =
    description: opts: default:
    lib.mkOption {
      type = types.attrsOf (
        types.submodule {
          options = opts;
        }
      );
      inherit description default;
    };

  mkAttrsSub =
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
