{
  description = "My NixOS configuration :)";

  outputs =
    { flakelight, ... }@inputs:
    flakelight ./. {
      inherit inputs;

      nixDir = ./.;

      systems = [ "x86_64-linux" ];

      # nixosConfigurations = {
      #   "coffee" = {
      #     system = "x86_64-linux";
      #     modules = [ { system.stateVersion = "24.05"; } ];
      #   };

      #   "pancake" = {
      #     system = "x86_64-linux";
      #     modules = [ { system.stateVersion = "24.05"; } ];
      #   };
      # };

      # templates = {
      #   "rust" = {
      #     path = ./rust;
      #     description = "Rust/Cargo project";
      #   };

      #   "typst" = {
      #     path = ./typst;
      #     description = "Typst writing project";
      #   };
      # };
    };

  inputs = rec {
    # ----- nixpkgs ---------------------------------------------------------------------------------------------------
    nixpkgs-24-11.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-24-05.url = "github:nixos/nixpkgs/nixos-24.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable = nixpkgs-24-11;
    nixpkgs = nixpkgs-stable;

    # ----- personal stuff --------------------------------------------------------------------------------------------
    # My wallpapers
    # Is an external flake to make sure this repo stays small if the wallpapers aren't used
    # (The url MUST use git+ssh otherwise it won't properly authenticate and have access to the private repo)
    wallpapers.url = "git+ssh://git@github.com/LeoLuxo/dots-wallpapers";

    # ----- flake and config ------------------------------------------------------------------------------------------
    # Manages dotfiles in nix
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # A modular Nix flake framework for simplifying flake definitions.
    # https://github.com/nix-community/flakelight/blob/master/API_GUIDE.md
    flakelight.url = "github:nix-community/flakelight";

    # Encryption library, used for secrets in nix
    agenix.url = "github:ryantm/agenix";

    # ----- hardware --------------------------------------------------------------------------------------------------
    # Contains certain nixos hardware settings, notably useful for surface laptops
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    # Real-time audio in NixOS
    musnix.url = "github:musnix/musnix";

    # ----- other -----------------------------------------------------------------------------------------------------
    # Catppuccin themes
    catppuccin.url = "github:catppuccin/nix";

    # Pre-built database for nix-index, which is an index of which files are provided by which packages
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # VSCode extensions repository
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

}
