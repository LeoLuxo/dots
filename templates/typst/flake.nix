{
  description = "A Typst project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    typix = {
      url = "github:loqusion/typix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    # https://loqusion.github.io/typix/recipes/using-typst-packages.html
    typst-packages = {
      url = "github:typst/packages";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      typix,
      flake-utils,
      typst-packages,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) lib;

        typixLib = typix.lib.${system};
        typstPackagesSrc = "${typst-packages}/packages";
        typstPackagesCache = pkgs.stdenv.mkDerivation {
          name = "typst-packages-cache";
          src = typstPackagesSrc;
          dontBuild = true;
          installPhase = ''
            mkdir -p "$out/typst/packages"
            cp -LR --reflink=auto --no-preserve=mode -t "$out/typst/packages" "$src"/*
          '';
        };

        project = {
          src = lib.sources.cleanSource ./.;
          typstSource = "main.typ";

          fontPaths = [
            # Add paths to fonts here
            # "${pkgs.roboto}/share/fonts/truetype"
          ];

          virtualPaths = [
            # Add paths that must be locally accessible to typst here
            # {
            #   dest = "icons";
            #   src = "${inputs.font-awesome}/svgs/regular";
            # }
          ];

          XDG_CACHE_HOME = typstPackagesCache;
        };

        # Compile a Typst project, *without* copying the result to the current directory
        build = typixLib.buildTypstProject project;

        # Compile a Typst project, and then copy the result to the current directory
        run = typixLib.buildTypstProjectLocal project;
      in
      {
        checks = {
          inherit run build;
        };

        packages.default = build;

        apps.default = flake-utils.lib.mkApp { drv = run; };

        devShells.default = typixLib.devShell {
          inherit (project) fontPaths virtualPaths;

          packages = [
            pkgs.tinymist
            pkgs.typstfmt
            pkgs.typstyle
          ];
        };
      }
    );
}