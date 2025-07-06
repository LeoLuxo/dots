{
  description = "My NixOS configuration :)";

  outputs =
    { nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystemPassThrough (
      system:
      let

        # The config for each of the nixpkgs instances
        nixpkgsConfig = {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

        pkgs = import inputs.nixpkgs nixpkgsConfig;
        otherPkgs = {
          pkgs-stable = import inputs.nixpkgs-stable nixpkgsConfig;
          pkgs-unstable = import inputs.nixpkgs-unstable nixpkgsConfig;

          pkgs-25-05 = import inputs.nixpkgs-25-05 nixpkgsConfig;
          pkgs-24-11 = import inputs.nixpkgs-24-11 nixpkgsConfig;
          pkgs-24-05 = import inputs.nixpkgs-24-05 nixpkgsConfig;
        };

        # Set up nixpks lib + my custom lib
        lib = pkgs.lib // {
          my = import ./lib {
            lib = pkgs.lib;
            inherit pkgs;
          };
        };

        nixosSystem = nixpkgs.lib.nixosSystem;

        importArgs = {
          inherit
            lib
            inputs
            pkgs
            otherPkgs
            nixosSystem
            ;
        };
      in
      {
        # Use a compatibility layer until I've transferred all the old modules to the new module system
        nixosConfigurations = import ./oldCompat.nix importArgs;

        nixosModules = import ./nixosModules importArgs;
      }
    );

  inputs = {
    # ----- nixpkgs -------------------------------------------------------------------------------
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-25-05.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-24-11.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-24-05.url = "github:nixos/nixpkgs/nixos-24.05";

    # ----- personal stuff ------------------------------------------------------------------------
    # My wallpapers
    # Is an external flake to make sure this repo stays small if the wallpapers aren't used
    # (The url MUST use git+ssh otherwise it won't properly authenticate and have access to the private repo)
    wallpapers.url = "git+ssh://git@github.com/LeoLuxo/dots-wallpapers";

    # ----- metaconfig & nix ---------------------------------------------------------------------
    # Manages dotfiles in nix
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Provides a set of tools to more easily manage flakes and per-system attrs
    flake-utils.url = "github:numtide/flake-utils";

    # Encryption library, used for secrets in nix
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      # optionally choose not to download darwin deps (saves some resources on Linux)
      inputs.darwin.follows = "";
    };

    # ----- hardware ------------------------------------------------------------------------------
    # Contains certain nixos hardware settings, notably useful for surface laptops
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    # Real-time audio in NixOS
    musnix.url = "github:musnix/musnix";

    # ----- other ---------------------------------------------------------------------------------
    # Catppuccin themes
    catppuccin.url = "github:catppuccin/nix";

    # Pre-built database for nix-index, which is an index of which files are provided by which packages
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # VSCode extensions repository
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

}
