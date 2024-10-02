{
  description = "My Nix configuration :)";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Contains certain nixos hardware settings, specifically for surface laptops
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    # Manages dotfiles in nix
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Encryption thingie, used for secrets in nix
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
      # Evaluate the root path right here, right now. This forces it to be the current path of the flake (in the nix store ofc) instead of being evaluated down the line in a module
      rootPath = "${./.}";

      # Some helper functions to avoid using relative paths
      getModule = path: rootPath + "/modules/${path}";
      getHostModule = path: rootPath + "/modules/host/${path}";
      getUserModule = path: rootPath + "/modules/user/${path}";
      getScript = path: rootPath + "/scripts/${path}";

      # Function to create a nixos config
      mkConfig = (
        system: module:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            module
          ];
          specialArgs = inputs // {
            inherit
              system
              getModule
              getHostModule
              getUserModule
              getScript
              ;
          };
        }
      );
    in
    {
      # Define nixos configs
      nixosConfigurations = {

        # Laptop (Surface Pro 7)
        "pancake" = mkConfig "x86_64-linux" ./hosts/pancake;

      };
    };
}
