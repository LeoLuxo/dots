{
  lib,
  pkgs,
}:

let
  inherit (lib)
    strings
    attrsets
    lists
    debug
    ;
in

rec {
  /**
    This function sanitizes a file system path to make it compatible with the Nix store

    # Example

    ```nix
    sanitizePath "/path/with spaces and special-chars!"
    =>
    /nix/store/hash-path-with-spaces-and-special-chars
    ```

    # Type

    ```
    sanitizePath :: Path -> Path
    ```

    # Arguments

    path
    : The filesystem path to be sanitized
  */
  sanitizePath =
    path:
    builtins.path {
      inherit path;
      name = strings.sanitizeDerivationName (builtins.baseNameOf path);
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
