libArgs:

let
  subModules = {
    modules = import ./modules.nix libArgs;
    options = import ./options.nix libArgs;
    paths = import ./paths.nix libArgs;
    strings = import ./strings.nix libArgs;
  };
in
subModules
# Re-export the sub-modules in the top-level lib
// subModules.options
// subModules.paths
// subModules.strings
// subModules.modules
