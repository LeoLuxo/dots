{
  description = "A Typst project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    typix = {
      url = "github:loqusion/typix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://loqusion.github.io/typix/recipes/using-typst-packages.html
    typst-packages = {
      url = "github:typst/packages";
      flake = false;
    };
  };

  outputs =
    {
      self,
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

          # Add the typst package cache in the cache so typst can read it
          XDG_CACHE_HOME = typstPackagesCache;

          # typst respects this env-var as "the current time", so add it for when datetime is used in the document
          SOURCE_DATE_EPOCH = builtins.toString self.sourceInfo.lastModified;
        };

        # Compile a Typst project, *without* copying the result to the current directory
        build = typixLib.buildTypstProject project;

        # Compile a Typst project, and then copy the result to the current directory
        buildCopy = typixLib.buildTypstProjectLocal project;
      in
      {
        checks = {
          inherit build buildCopy;
        };

        packages.default = build;

        apps.default = flake-utils.lib.mkApp { drv = buildCopy; };

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
