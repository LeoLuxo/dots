{
  description = "My NixOS configuration :)";

  outputs =
    { flakelight, ... }@inputs:
    flakelight ./. (
      { lib, ... }:

      # let
      #   createPkgs =
      #     system: nixpkgs:
      #     import nixpkgs {
      #       inherit system;
      #       config.allowUnfree = true;
      #     };

      #   specialPkgs = system: {
      #     pkgsStable = createPkgs system inputs.nixpkgs-stable;
      #     pkgsUnstable = createPkgs system inputs.nixpkgs-unstable;
      #     pkgs24-05 = createPkgs system inputs.nixpkgs-24-05;
      #     pkgs24-11 = createPkgs system inputs.nixpkgs-24-11;
      #     pkgs25-05 = createPkgs system inputs.nixpkgs-25-05;
      #   };
      # in
      {
        # Will use "nixpkgs" as the default nixpkgs
        inherit inputs;

        nixDir = ./.;

        systems = [ "x86_64-linux" ];

        # Use a compatibility layer until I've transferred all the old modules to the new module system
        nixosConfigurations = import ./flakelightCompat.nix { inherit lib inputs; };
      }
    );

  inputs = rec {
    # ----- nixpkgs -------------------------------------------------------------------------------
    nixpkgs-25-05.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-24-11.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-24-05.url = "github:nixos/nixpkgs/nixos-24.05";

    nixpkgs-stable = nixpkgs-24-11;
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs = nixpkgs-unstable;

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

    # A modular Nix flake framework for simplifying flake definitions.
    # https://github.com/nix-community/flakelight/blob/master/API_GUIDE.md
    flakelight.url = "github:nix-community/flakelight";

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
