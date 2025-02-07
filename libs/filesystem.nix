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
  # Sanitize a path so that it doesn't cause problems in the nix store
  sanitizePath =
    path:
    builtins.path {
      inherit path;
      name = strings.sanitizeDerivationName (builtins.baseNameOf path);
    };

  /**
    A function that imports and processes NixOS modules with namespace support and optional recursive import processing.

    # Example

    ```nix
    importModuleFile {
      file = ./my-module.nix;
      namespace = [ "myapp" "feature" ];
      processImports = true;
    }
    =>
    A module with its options namespaced under config.myapp.feature
    ```

    # Type

    ```
    importModuleFile :: {
      file :: Path,
      namespace :: [String],
      processImports :: Bool
    } -> ModuleInputs -> Module
    ```

    # Arguments

    file
    : Path to the NixOS module file to import

    namespace
    : Optional list of strings that will be used to nest the module's options under a namespace path.
      Empty list by default.

    processImports
    : Whether to recursively process imports in the target module.
      If true, will wrap imported paths with the same namespace.
      Defaults to false.

    # Notes

    - Provides the imported module with additional inputs:
      - namespace: The current namespace path
      - cfg: Shortcut to access the namespaced config
    - Processes imports recursively when processImports is true
    - Wraps all options under the specified namespace path
    - Preserves the original module's config and non-path imports
  */
  importModuleFile =
    {
      file,
      namespace ? [ ],
      processImports ? false,
    }:
    # Returns a nixos module that re-imports the file
    moduleInputs:
    let
      # Inputs for the module, which also includes:
      # - namespace
      # - cfg, which is a shorcut for `config.n1.n2.(...).ni` for each `n` in namespace
      inputs = moduleInputs // {
        inherit namespace;
        cfg = lists.foldl (cfg: name: cfg.${name}) moduleInputs.config namespace;
      };

      # Import the module and provide the inputs
      importedModule = (import file) (debug.traceValSeq inputs);

      # Modify the module's imports and options
      modifiedModule = (
        debug.traceValSeq {
          # Copy over config
          config = importedModule.config or { };

          # Process each of the imports
          imports = lists.concatMap (
            importPath:
            # If import processing is enabled and it's a path
            if processImports && strings.isPath importPath then
              if builtins.isDir importPath then
                # If it's a dir, load the default file
                importModuleFile {
                  file = "${importPath}/default.nix";
                  inherit namespace processImports;
                }
              else
                # If it's a file, load the file itself
                importModuleFile {
                  file = importPath;
                  inherit namespace processImports;
                }
            else
              importPath
          ) (importedModule.imports or [ ]);

          # Modify the options field of the module to prefix it with the namespace:
          # so `options.myOption = mkOption {...}` => `options.n1.n2.(...).ni.myOption = mkOption {...}` for each `n` in namespace
          options = lists.foldr (name: opt: { ${name} = opt; }) (importedModule.options or { }) namespace;
        }
      );
    in
    {
      imports = [
        modifiedModule
      ];
    };

  importModuleDir =
    {
      dir,
      namespace ? [ ],
    }:
    # Returns a nixos module that imports all of the sub-modules
    moduleInputs: {
      imports = debug.traceValSeq (
        lists.flatten (
          # If there's a default.nix file present, load that directly and process its imports
          let
            defaultFile = "${dir}/default.nix";
          in
          if builtins.pathExists defaultFile then
            [
              (importModuleFile {
                file = defaultFile;
                inherit namespace;
                processImports = true;
              })
            ]

          else
            # Otherwise, recursively go through the files and directories from the given dir
            attrsets.mapAttrsToList (
              fileName: type:
              let
                path = dir + "/${fileName}";
              in

              if type == "directory" then
                # Recursively descend into the dir
                importModuleDir {
                  # Make sure to append the dir name to the path
                  dir = path;
                  # And add it to the namespace
                  namespace = namespace ++ [ fileName ];
                }

              else if type == "regular" then
                importModuleFile {
                  file = path;
                  namespace = namespace ++ [ fileName ];
                  processImports = false;
                }

              else
                # Ignore incompatible files, but emit a warning
                lib.warn "Found bad file '${fileName}' of type '${type}' while loading modules" [ ]

            ) (builtins.readDir dir)
        )
      );
    };
}
