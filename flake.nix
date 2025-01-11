{
  description = "My NixOS configuration :)";

  inputs = {
    # Using nixpkgs unstable
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # Manages dotfiles in nix
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My wallpapers
    # Is an external flake to make sure this repo stays small if the wallpapers aren't used
    # (The url MUST use git+ssh otherwise it won't properly authenticate and have access to the private repo)
    wallpapers = {
      url = "git+ssh://git@github.com/LeoLuxo/dots-wallpapers";
    };

    # Contains certain nixos hardware settings, notably useful for surface laptops
    nixos-hardware = {
      url = "github:nixos/nixos-hardware/master";
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
    catppuccin = {
      url = "github:catppuccin/nix";
    };

    # Pre-built database for nix-index, which is an index of which files are provided by which packages
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Real-time audio in NixOS 
    musnix = {
      url = "github:musnix/musnix";
    };

    # VSCode extensions repository
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:

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

            userKeyPrivate = "${userHome}/.ssh/id_ed25519";
            userKeyPublic = "${userKeyPrivate}.pub";
            hostKeyPrivate = "/etc/ssh/ssh_host_ed25519_key";
            hostKeyPublic = "${hostKeyPrivate}.pub";

            dotsRepoPath = (nixosPath + "/dots");
          };

          constants = defaultConstants // hostConstants;

          extraLib = import ./libs.nix {
            inherit inputs constants;
          };

          nixosModules = extraLib.findFiles {
            dir = ./modules;
            extensions = [ "nix" ];
            defaultFiles = [ "default.nix" ];
          };

        in
        nixpkgs.lib.nixosSystem {
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
    {
      # Define nixos configs
      nixosConfigurations = import ./hosts.nix mkHost;

      # Define templates
      templates = import ./templates;
    };
}
