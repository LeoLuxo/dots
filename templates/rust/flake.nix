{
  inputs = {
    # Import the latest unstable version of nixpkgs
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # Import flake-utils for utility functions
    flake-utils.url = "github:numtide/flake-utils";

    # Used to format all kinds of files
    treefmt-nix.url = "github:numtide/treefmt-nix";

    # Used to build the project by parsing the cargo dependencies
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Used to generate/get a specific rust toolchain to use with naersk
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
      naersk,
      fenix,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        # Import nixpkgs for the current system
        pkgs = nixpkgs.legacyPackages.${system};

        # Define the Rust toolchain using fenix, by reading rust-toolchain.toml
        rustToolchain =
          with fenix.packages.${system};
          fromToolchainFile {
            dir = ./.;
            sha256 = "sha256-s1RPtyvDGJaX/BisLT+ifVfuhDT1nZkZ1NcK8sbwELM=";
          };

        # Define the package using naersk with the specified Rust toolchain
        package =
          (naersk.lib.${system}.override {
            cargo = rustToolchain;
            rustc = rustToolchain;
          }).buildPackage
            { src = ./.; };

        # Define the development shell with necessary tools
        devShell = pkgs.mkShell {
          inputsFrom = [ package ];
          buildInputs = with pkgs; [
            rustToolchain
            pre-commit
            rust-analyzer
          ];

          # Needed for rust-analyser to work
          RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
        };

        # Setup treefmt with the formatters we need
        treefmtEval = treefmt-nix.lib.evalModule pkgs (
          { ... }:
          {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true; # For nix files
              rustfmt.enable = true; # For rust files
            };
          }
        );
      in
      {
        # For `nix build` and `nix run`
        packages.default = package;

        # For `nix develop`
        devShells.default = devShell;

        # For `nix fmt`
        formatter = treefmtEval.config.build.wrapper;

        # For `nix flake check`
        checks.formatting = treefmtEval.config.build.check self;
      }
    );
}
