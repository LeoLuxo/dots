{ lib, ... }:

let
  inherit (lib)
    strings
    attrsets
    lists
    debug
    types
    options
    ;
in

rec {

  mkNullOr =
    type:
    options.mkOption {
      type = types.nullOr type;
      default = null;
    };

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

  importModules =
    dir:
    # Returns a nixos module that imports all of the sub-modules
    moduleInputs: {
      imports = lists.flatten (
        let
          defaultFile = "${dir}/default.nix";
        in
        if builtins.pathExists defaultFile then
          # If there's a default.nix file present, import that directly and don't process further files in the dir
          [ (debug.traceValFn (x: "default file: ${builtins.toString x}") defaultFile) ]
        else
          # Otherwise, recursively go through the files and directories from the given dir
          attrsets.mapAttrsToList (
            fileName: type:
            let
              path = dir + "/${fileName}";
            in

            if type == "directory" then
              # Recursively descend into the dir
              importModules {
                # Make sure to append the dir name to the path
                dir = debug.traceValFn (x: "directory: ${builtins.toString x}") path;
              }

            else if type == "regular" && strings.hasSuffix ".nix" fileName then
              # Add nix files
              (debug.traceValFn (x: "file: ${builtins.toString x}") path)

            else
              # Ignore incompatible files
              [ ]

          ) (builtins.readDir dir)
      );
    };
}
