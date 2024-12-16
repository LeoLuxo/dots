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

    # Tool for customizing/theming nixos
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Catppuccin themes
    catppuccin.url = "github:catppuccin/nix";

    # Pre-built database for nix-index, which is an index of which files are provided by which packages
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Real-time audio in NixOS 
    musnix = {
      url = "github:musnix/musnix";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:

    let
      # Function to create a nixos host config
      mkHost =
        modules:
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
            dotsRepoPath = (nixosPath + "/dots");
            secretsRepoPath = (nixosPath + "/secrets");
          };

          const = {
            constants = defaultConstants // hostConstants;
          };

          libs = {
            extra-libs = import ./libs.nix (inputs // const);
          };

          dirs = {
            directories = import ./dirs.nix (inputs // libs // const);
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit (hostConstants) system;
          inherit modules;

          # Additional args passed to the module
          specialArgs = inputs // libs // dirs // const;
        };

    in
    {
      # Define nixos configs
      nixosConfigurations = import ./hosts.nix mkHost;

      # Define templates
      templates = import ./templates;
    };
}
