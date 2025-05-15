{ lib, ... }:

{
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

}
