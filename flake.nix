# https://github.com/IogaMaster/snowfall-starter

# https://github.com/jakehamilton/config

{
  description = "My NixOS configuration :)";

  inputs = {
    # Using nixpkgs unstable
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # Snowfall Lib is a library that makes it easy to manage your Nix flake by imposing an opinionated file structure.
    # The name "snowfall-lib" is required due to how Snowfall Lib processes your flake's inputs.
    snowfall-lib = {
      # Using a fork until this PR gets merged https://github.com/snowfallorg/lib/pull/131
      url = "github:elliott-farrall/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Manages dotfiles and home/user config in nix
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
    inputs:
    # [Snowfall Lib](https://snowfall.org/guides/lib/quickstart/) is a library that standardizes the creation of flake outputs.
    #
    # Snowfall Lib automatically maps these directories to flake outputs:
    # Root Directory: ./
    # ├── homes/
    # │   └── <arch>-<format>/         -> e.g. x86_64-linux, aarch64-darwin
    # │       └── <name>/default.nix   -> home configuration
    # │
    # ├── systems/
    # │   └── <arch>-<format>/         -> e.g. x86_64-linux, aarch64-darwin
    # │       └── <name>/default.nix   -> system configuration
    # │
    # ├── lib/
    # │   └── <name>/default.nix       -> lib.${namespace}.<name>
    # │
    # ├── modules/
    # │   ├── home/                    -> homes.modules.<name>
    # │   └── nixos/                   -> nixosModules.<name>
    # │
    # ├── overlays/                    -> overlays.<name>
    # │   └── <name>/default.nix
    # │
    # ├── packages/
    # │   └── <name>/                  -> packages.<system>.<name>
    # │
    # ├── checks/                      -> checks.<system>.<name>
    # │   └── <name>/
    # │
    # └── shells/
    #     └── <name>/                  -> devShells.<system>.<name>
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      channels-config = {
        allowUnfree = true;
      };

      # NixOS modules for all hosts
      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
        agenix.nixosModules.default
        musnix.nixosModules.musnix
      ];

      # NixOS modules for specific hosts
      systems.hosts = {
        pancake.modules = with inputs; [
          # Include hardware stuff and kernel patches for surface pro 7
          nixos-hardware.nixosModules.microsoft-surface-pro-intel
        ];
      };

      templates = import ./templates;

    };
}
