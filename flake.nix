{
  description = "My Nix configuration :)";

  inputs = {
    # Specify the source Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Contains certain nixos hardware settings, specifically for surface laptops
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    # Manages dotfiles in nix
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Encryption thingie to encrypt and decrypt secrets
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      # optionally choose not to download darwin deps (saves some resources on Linux)
      inputs.darwin.follows = "";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:

    let
      # Unlocked on purpose, means it always fetches the newest version, and forces the secrets flake to be built FIRST
      # -> the secrets are decrypted before the flake here is evaluated, thus making it possible to read secrets inline
      secretsFlake = (builtins.getFlake "git+file:///etc/nixos/secrets");

      # Evaluate the root path right here, right now. This forces it to be the current path of the flake (in the nix store ofc) instead of being evaluated down the line in a module
      # rootPath = "${./.}";

      # Some helper paths to avoid using relative paths
      modules = ./modules;
      hostModules = ./modules/host;
      userModules = ./modules/user;
      scripts = ./scripts;

      # Some helper functions

      # Function to create a nixos config
      mkConfig = (
        system: module:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            module
            secretsFlake.nixosModules.default
          ];
          specialArgs = inputs // {
            inherit
              system
              modules
              hostModules
              userModules
              scripts
              ;
          };
        }
      );

    in
    {
      # Define our nixos configs
      nixosConfigurations = {

        # Laptop (Surface Pro 7)
        "pancake" = mkConfig "x86_64-linux" ./hosts/pancake;

      };
    };
}
