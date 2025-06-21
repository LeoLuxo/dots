{
  inputs,
  lib,
}:

let

  # Given a nixpkgs input, creates a pkgs instance
  createPkgs =
    system: nixpkgs:
    import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

  # specialPkgs = system: {
  #   pkgsStable = createPkgs system inputs.nixpkgs-stable;
  #   pkgsUnstable = createPkgs system inputs.nixpkgs-unstable;
  #   pkgs24-05 = createPkgs system inputs.nixpkgs-24-05;
  #   pkgs24-11 = createPkgs system inputs.nixpkgs-24-11;
  #   pkgs25-05 = createPkgs system inputs.nixpkgs-25-05;
  # };

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
      user,
      hostname,
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
      specialArgs = (lib.traceVal (specialPkgs system)) // {
        inherit
          inputs
          extraLib
          nixosModulesOld
          constants
          hostname
          ;
      };
    };

in
# Define nixos configs
import ./old/hosts.nix {
  inherit mkHost;
  newModules = inputs.self.nixosModules.default;
}
