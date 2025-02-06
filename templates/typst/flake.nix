{
  description = "A Typst project";

  inputs = {
    # Import the latest unstable version of nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Import flake-utils for utility functions
    flake-utils.url = "github:numtide/flake-utils";

    # Import typix for building Typst projects
    typix = {
      url = "github:loqusion/typix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Import full Typst packages repository
    # https://loqusion.github.io/typix/recipes/using-typst-packages.html
    typst-packages = {
      url = "github:typst/packages";
      flake = false;
    };

    # Used to format all kinds of files
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      typix,
      flake-utils,
      typst-packages,
      treefmt-nix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        # Import nixpkgs for the current system
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) lib;

        # Import typix library for the current system
        typixLib = typix.lib.${system};

        # Create the cache for Typst packages
        typstPackagesCache = pkgs.stdenv.mkDerivation {
          name = "typst-packages-cache";
          src = "${typst-packages}/packages";
          dontBuild = true;
          installPhase = ''
            mkdir -p "$out/typst/packages"
            cp -LR --reflink=auto --no-preserve=mode -t "$out/typst/packages" "$src"/*
          '';
        };

        # Define extra arguments for the project
        projectExtraArgs = {
          # Include the whole directory
          src = lib.sources.cleanSource ./.;

          # Add the Typst package cache so Typst can read it
          XDG_CACHE_HOME = typstPackagesCache;

          # typst respects this env-var as "the current time", so add it for when datetime is used in the document
          SOURCE_DATE_EPOCH = builtins.toString self.sourceInfo.lastModified;
        };

        # Define the Typst project
        project = {
          typstSource = "main.typ";

          fontPaths = [
            # Add paths to fonts here
            # "${pkgs.roboto}/share/fonts/truetype"
          ];

          virtualPaths = [
            # Add paths that must be locally accessible to Typst here
            # {
            #   dest = "icons";
            #   src = "${inputs.font-awesome}/svgs/regular";
            # }
          ];
        };

        # Compile the Typst project, *without* copying the result to the current directory
        build = typixLib.buildTypstProject (project // projectExtraArgs);

        # Compile the Typst project and copy the result to the current directory
        buildAndCopy = typixLib.buildTypstProjectLocal (project // projectExtraArgs);

        # Watch the Typst project and recompile on changes
        watch = typixLib.watchTypstProject project;

        # Setup treefmt with the formatters we need
        treefmtEval = treefmt-nix.lib.evalModule pkgs (
          { ... }:
          {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true; # For nix files
              typstfmt.enable = true; # For typst files
              texfmt.enable = true; # For tex, sty and bib files
            };
          }
        );
      in
      rec {
        checks = {
          inherit build buildAndCopy watch;
        };

        packages.default = build;

        apps = {
          buildAndCopy = flake-utils.lib.mkApp { drv = buildAndCopy; };
          watch = flake-utils.lib.mkApp { drv = watch; };
        };

        apps.default = apps.buildAndCopy;

        devShells.default = typixLib.devShell {
          inherit (project) fontPaths virtualPaths;

          packages = [
            pkgs.tinymist
            pkgs.typstfmt
            pkgs.typstyle
          ];
        };

        # For `nix fmt`
        formatter = treefmtEval.config.build.wrapper;

        # For `nix flake check`
        checks.formatting = treefmtEval.config.build.check self;
      }
    );
}
