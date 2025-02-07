{
  cfg,
  lib,
  ...
}:

let
  inherit (lib) options types;
in
{
  # Apply one or more patches to a package without having to create an entire overlay for it
  options = options.mkOption {
    type = types.attrsOf (types.listOf types.path);
  };

  config = lib.mapAttrs' (package: quickPatch: {
    nixpkgs.overlays = [
      (final: prev: {
        ${package} = prev.${package}.overrideAttrs (
          finalAttrs: oldAttrs: { patches = (prev.patches or [ ]) ++ quickPatch.patches; }
        );
      })
    ];
  }) cfg;
}
