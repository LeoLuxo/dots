{
  inputs = {
    # Import the latest unstable version of nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Import flake-utils for utility functions
    flake-utils.url = "github:numtide/flake-utils";

    # Used to generate/get a specific rust toolchain to use with naersk
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Used to build the project by parsing the cargo dependencies
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      rust-overlay,
      naersk,
    }:
    flake-utils.lib.eachDefaultSystemPassThrough (
      system:
      let
        # Import nixpkgs for the current system
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };

        # Define the Rust toolchain by reading rust-toolchain.toml
        toolchain = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;

        # Intialize naersk with the created toolchain
        naersk' = pkgs.callPackage naersk {
          cargo = toolchain;
          rustc = toolchain;
        };

        libraries = [ ];
      in
      {
        # For `nix build` and `nix run`.
        # Build the package using naersk
        packages.${system}.default = naersk'.buildPackage {
          src = ./.;
        };

        # For `nix develop`.
        # Define the development shell with necessary tools
        devShells.${system}.default = pkgs.mkShell {
          nativeBuildInputs = [ toolchain ];
          buildInputs =
            with pkgs;
            libraries
            ++ [
              rustfmt
              pre-commit
              rust-analyzer
              rustPackages.clippy

              cargo-limit # Provides `cargo lcheck` (etc) with less noise than the regular commands
              cargo-expand # Provides `cargo expand` to expand macros definitions
            ];

          # Needed for rust-analyser to work
          RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";

          # Make libraries available to cargo
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath libraries;
        };
      }
    );
}
