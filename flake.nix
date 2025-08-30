{
  description = "My NixOS configuration :)";

  # https://nixos.wiki/wiki/flakes#Flake_schema
  outputs =
    { nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystemPassThrough (
      system:

      let
        # The default lib just so I can pass it around where needed
        lib = nixpkgs.legacyPackages.${system}.lib;
        lib2 = import ./lib.nix { inherit lib; };

        args = { inherit inputs lib lib2; };

        hosts = import ./hosts args;
        nixos = import ./nixos args;
        home = import ./home args;
      in
      {
        nixosConfigurations = {
          "coffee" = hosts.coffee.nixos args;
          # "pancake" = hosts.pancake.nixos args;
        };

        nixosModules = nixos.modules;
        nixosProfiles = nixos.profiles; # Not a recognized flake output

        homeManagerConfigurations = {
          "lili@coffee" = hosts.coffee.home args;
          # "lili@pancake" = hosts.pancake.home args;
        };

        homeModules = home.modules; # Not a recognized flake output (the correct one would be homeManagerModules)
        homeProfiles = home.profiles; # Not a recognized flake output

        overlays = {
          "pkgs" = import ./pkgs.nix args;
          "builders" = import ./builders.nix args;
        };
      }
    );

  inputs = {
    # ----- nixpkgs -------------------------------------------------------------------------------
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
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
      url = "github:nix-community/home-manager/release-25.05";
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
