inputs:

let
  subModules = {
    options = import ./options.nix inputs;
    paths = import ./paths.nix inputs;
    strings = import ./strings.nix inputs;
  };
in
subModules
# Re-export the sub-modules in the top-level lib
// subModules.options
// subModules.paths
// subModules.strings
