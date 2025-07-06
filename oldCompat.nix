{
  inputs,
  lib,
  lib2,
}:

let

  # Given a nixpkgs input, creates a pkgs instance
  createPkgs =
    system: nixpkgs:
    import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

  # Gathers all EXTRA nixpkgs-xxx instances from the flake inputs
  allNixpkgs = lib.attrsets.filterAttrs (name: _: lib.strings.hasPrefix "nixpkgs-" name) inputs;

  # Given a system, maps all nixpkgs-xxx instances to an appropriately named pkgs-xxx instance
  specialPkgs =
    system:
    lib.attrsets.mapAttrs' (name: value: {
      name = "pkgs" + (lib.strings.removePrefix "nixpkgs" name);
      value = createPkgs system value;
    }) allNixpkgs;

  # Function to create a nixos host config
  mkHost =
    hostModules:
    {
      hostname,
      system,
      ...
    }@hostConstants:
    let
      defaultConstants = rec {
        # userHome = "/home/${user}";
        nixosPath = "/etc/nixos";
        secretsPath = "/home/lili/misc/secrets";

        dotsRepoPath = (nixosPath + "/dots");
      };

      constants = defaultConstants // hostConstants;

      extraLib = import ./old/libs.nix {
        inherit inputs constants;
      };

      nixosModulesOld = extraLib.findFiles {
        dir = ./old/modules;
        extensions = [ "nix" ];
        defaultFiles = [ "default.nix" ];
      };

    in
    lib.nixosSystem {
      inherit system;
      modules = hostModules;

      # Additional args passed to the module
      specialArgs = (specialPkgs system) // {
        inherit
          inputs
          extraLib
          lib2
          nixosModulesOld
          constants
          hostname
          system
          ;
      };
    };

in
# Define nixos configs
import ./old/hosts.nix {
  inherit mkHost;
  newModules = inputs.self.nixosModules.default;
}
