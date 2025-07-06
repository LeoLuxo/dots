{
  inputs,
  nixosSystem,
  lib,
  otherPkgs,
  ...
}:

let

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
    nixosSystem {
      inherit system;
      modules = hostModules;

      # Additional args passed to the module
      specialArgs = {
        inherit
          lib
          inputs
          extraLib
          nixosModulesOld
          constants
          hostname
          system
          ;
      } // otherPkgs;
    };

in
# Define nixos configs
import ./old/hosts.nix {
  inherit mkHost;
  newModules = inputs.self.nixosModules.default;
}
