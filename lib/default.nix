# These extra libs are accessible in nixos modules under `pkgs.lib2`

libArgs:
let
  subModules = rec {
    modules = import ./modules.nix libArgs;
    options = import ./options.nix libArgs;
    utils = import ./utils.nix libArgs;
    strings = import ./strings.nix libArgs;
    builders = import ./builders.nix (libArgs // { inherit strings; });
  };
in
subModules
# Re-export the sub-modules in the top-level lib
// subModules.modules
// subModules.options
// subModules.utils
// subModules.strings
// subModules.builders
