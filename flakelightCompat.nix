{
  inputs,
  lib,
}:

let

  createPkgs =
    system: nixpkgs:
    import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

  specialPkgs = system: {
    pkgsStable = createPkgs system inputs.nixpkgs-stable;
    pkgsUnstable = createPkgs system inputs.nixpkgs-unstable;
    pkgs24-05 = createPkgs system inputs.nixpkgs-24-05;
    pkgs24-11 = createPkgs system inputs.nixpkgs-24-11;
    pkgs25-05 = createPkgs system inputs.nixpkgs-25-05;
  };

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

      nixosModulesOld = extraLib.findFiles {
        dir = ./old/modules;
        extensions = [ "nix" ];
        defaultFiles = [ "default.nix" ];
      };

    in
    lib.nixosSystem {
      inherit (hostConstants) system;
      modules = hostModules;

      # Additional args passed to the module
      specialArgs = (specialPkgs system) // {
        inherit
          inputs
          extraLib
          nixosModulesOld
          constants
          ;
      };
    };

in
# Define nixos configs
import ./old/hosts.nix mkHost
