{
  lib,
  ...
}:

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
      name = lib.strings.sanitizeDerivationName (builtins.baseNameOf path);
    };

  /**
    Recursively imports all Nix files from a directory, creating an attribute set where each key
    corresponds to the filename (without .nix extension) and the value is the imported content.

    # Example

    ```nix
    recursivelyImportDir ./configs
    =>
    {
      nginx = <imported nginx.nix>;
      postgres = <imported postgres.nix>;
      redis = { ... } # from redis/default.nix
    }
    ```

    # Type

    ```
    recursivelyImportDir :: Path -> AttrSet
    ```

    # Arguments

    path
    : Directory path to recursively import from

    # Details

    - Skips default.nix files in the root directory
    - Handles both direct .nix files and directories with default.nix
    - Supports files with underscore prefix (e.g., _filename.nix)
    - Creates nested attribute sets for subdirectories
    - File priority: filename.nix > _filename.nix > directory/default.nix
  */
  recursivelyImportDir =
    path:
    lib.genAttrs
      (lib.pipe (builtins.readDir path) [
        lib.traceVal
        lib.attrNames
        (lib.filter (s: s != "default.nix"))
        (lib.filter (s: (lib.hasSuffix ".nix" s) || lib.pathExists (path + "/${s}/default.nix")))
        (map (lib.removeSuffix ".nix"))
        (map (lib.removePrefix "_"))
      ])
      (
        p:
        let
          file = path + "/${p}.nix";
          underscoreFile = path + "/_${p}.nix";
          dir = path + "/${p}";
          defaultFile = dir + "/default.nix";
        in
        if lib.pathExists file then
          # import file
          { }
        else if lib.pathExists underscoreFile then
          # import underscoreFile
          { }
        else if lib.pathExists defaultFile then
          # import dir
          { }
        else
          # recursivelyImportDir dir
          { }
      );

  /**
    Recursively imports all Nix files from a directory into a flat list,
    excluding default.nix files.

    # Example

    ```nix
    recursivelyImportDirToList ./modules
    =>
    [ moduleA moduleB moduleC.submodule1 moduleC.submodule2 ]
    ```

    # Type

    ```
    recursivelyImportDirToList :: Path -> [Any]
    ```

    # Arguments

    path
    : The directory path to recursively import from

    # Details

    - Skips files named "default.nix"
    - For directories, if they contain default.nix, imports that file
    - For directories without default.nix, recursively imports their contents
    - For .nix files, imports them directly
    - Flattens the resulting nested lists into a single list
  */
  recursivelyImportDirToList =
    dirPath:
    let
      importPath =
        name: type:
        let
          path = dirPath + "/${name}";
        in
        if name == "default.nix" then
          [ ]
        else if type == "directory" then
          if lib.pathExists (path + "/default.nix") then
            [ (import path) ]
          else
            recursivelyImportDirToList path
        else if type == "regular" && lib.hasSuffix ".nix" name then
          [ (import path) ]
        else
          [ ];
    in
    lib.flatten (lib.mapAttrsToList importPath (builtins.readDir dirPath));

}
