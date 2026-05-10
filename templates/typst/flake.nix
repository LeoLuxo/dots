{
  inputs = {
    # The latest unstable version of nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # For utility functions
    flake-utils.url = "github:numtide/flake-utils";

    # To extract typst dependencies
    typst2nix = {
      url = "github:chlookie/typst2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # To build typst projects
    press.url = "github:RossSmyth/press";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      typst2nix,
      press,
    }:
    flake-utils.lib.eachDefaultSystemPassThrough (
      system:
      let
        # Import nixpkgs for the current system and overlays
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (import typst2nix)
            (import press)
          ];
        };

        # The typst document to compile
        document = pkgs.buildTypstDocument rec {
          name = "document";
          file = "main.typ";
          src = ./src;

          creationTimestamp =
            builtins.currentTime
              or (pkgs.lib.warn "Missing `currentTime`, timestamps might be wrong! Run using `--impure` to get proper timestamps." self.lastModified);

          # Autoextract typst module dependencies
          typstEnv = (typst2nix.lib.extractDependencies { path = src; });

          fonts = [
            # Default typst fonts
            pkgs.libertinus
            pkgs.newcomputermodern
            pkgs.dejavu_fonts
          ];
        };
      in
      {
        # Build the typst document
        packages.${system}.default = document;

        # Copy the built document to a PDF file in its own directory
        apps.${system}.default = pkgs.copyTypstDocumentApp {
          inherit document;
          path = "pdf/document.pdf";
        };

        # For `nix develop`
        # Define the development shell with necessary tools
        devShells.${system}.default = pkgs.mkShell {
          inputsFrom = [ document ];

          packages = with pkgs; [
            tinymist
          ];
        };
      }
    );
}
