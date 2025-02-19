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

    # A modular Nix flake framework for simplifying flake definitions.
    # https://github.com/nix-community/flakelight/blob/master/API_GUIDE.md
    flakelight.url = "github:nix-community/flakelight";

    # My wallpapers
    # Is an external flake to make sure this repo stays small if the wallpapers aren't used
    # (The url MUST use git+ssh otherwise it won't properly authenticate and have access to the private repo)
    wallpapers.url = "git+ssh://git@github.com/LeoLuxo/dots-wallpapers";

    # Contains certain nixos hardware settings, notably useful for surface laptops
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

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
    musnix.url = "github:musnix/musnix";

    # VSCode extensions repository
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs =
    { flakelight, ... }@inputs:
    flakelight ./. {
      inherit inputs;

      # nixDir = ./nix;

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

}
