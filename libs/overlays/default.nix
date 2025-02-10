{
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};

{
  /**
    Creates an overlay that patches a package without requiring a full overlay definition.
    Useful for quick package modifications through patching.

    # Example

    ```nix
    mkQuickPatch {
      package = "hello";
      patches = [ ./fix-bug.patch ];
    }
    =>
    final: prev: {
      hello = prev.hello.overrideAttrs (...);
    }
    ```

    # Type

    ```
    mkQuickPatch :: { package :: String, patches :: [ Path ] } -> (Final -> Prev -> Attrset)
    ```

    # Arguments

    package
    : The name of the package to patch as a string

    patches
    : List of patch files to apply to the package

    # Returns

    An overlay function that when applied will override the specified package with the given patches
  */
  mkQuickPatch =
    { package, patches }:
    final: prev: {
      ${package} = prev.${package}.overrideAttrs (
        finalAttrs: oldAttrs: { patches = (prev.patches or [ ]) ++ quickPatch.patches; }
      );
    };
}
