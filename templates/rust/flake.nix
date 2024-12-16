{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

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
      naersk,
      fenix,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
        };

        rustToolchain =
          with fenix.packages.${system};
          fromToolchainFile {
            dir = ./.;
            sha256 = "sha256-s1RPtyvDGJaX/BisLT+ifVfuhDT1nZkZ1NcK8sbwELM=";
          };
      in
      rec {
        # For `nix build` and `nix run`
        packages.default =
          (naersk.lib.${system}.override {
            cargo = rustToolchain;
            rustc = rustToolchain;
          }).buildPackage
            {
              src = ./.;
            };

        # For `nix develop` and `direnv allow`
        devShell = pkgs.mkShell {
          inputsFrom = [ packages.default ];
          buildInputs = with pkgs; [
            rustToolchain

            pre-commit
            rust-analyzer
          ];

          # Needed for rust-analyser to work
          RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
        };
      }
    );
}
