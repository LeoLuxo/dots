{ inputs, lib }:

let
  # Function to create a nixos host config
  mkHost =
    hostModules:
    {
      user,
      hostName,
      system,
      ...
    }@hostConstants:
    let
      defaultConstants = rec {
        userHome = "/home/${user}";
        nixosPath = "/etc/nixos";
        secretsPath = "${userHome}/misc/secrets";

        userKeyPrivate = "${userHome}/.ssh/id_ed25519";
        userKeyPublic = "${userKeyPrivate}.pub";
        hostKeyPrivate = "/etc/ssh/ssh_host_ed25519_key";
        hostKeyPublic = "${hostKeyPrivate}.pub";

        dotsRepoPath = (nixosPath + "/dots");
      };

      constants = defaultConstants // hostConstants;

      extraLib = import ./old/libs.nix {
        inherit inputs constants;
      };

      nixosModules = extraLib.findFiles {
        dir = ./old/modules;
        extensions = [ "nix" ];
        defaultFiles = [ "default.nix" ];
      };

    in
    lib.nixosSystem {
      inherit (hostConstants) system;
      modules = hostModules;

      # Additional args passed to the module
      specialArgs = {
        inherit
          inputs
          extraLib
          nixosModules
          constants
          ;
      };
    };

in
# Define nixos configs
import ./old/hosts.nix mkHost
