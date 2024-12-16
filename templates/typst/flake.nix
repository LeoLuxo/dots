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

        typstPackagesCache = pkgs.stdenv.mkDerivation {
          name = "typst-packages-cache";
          src = "${typst-packages}/packages";
          dontBuild = true;
          installPhase = ''
            mkdir -p "$out/typst/packages"
            cp -LR --reflink=auto --no-preserve=mode -t "$out/typst/packages" "$src"/*
          '';
        };

        projectExtraArgs = {
          # Include the whole dir
          src = lib.sources.cleanSource ./.;

          # Add the typst package cache in the cache so typst can read it
          XDG_CACHE_HOME = typstPackagesCache;

          # typst respects this env-var as "the current time", so add it for when datetime is used in the document
          SOURCE_DATE_EPOCH = builtins.toString self.sourceInfo.lastModified;
        };

        project = {
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
        };

        # Compile the typst project, *without* copying the result to the current directory
        build = typixLib.buildTypstProject (project // projectExtraArgs);

        # Compile the typst project, and then copy the result to the current directory
        buildAndCopy = typixLib.buildTypstProjectLocal (project // projectExtraArgs);

        # Watch the typst project and recompile on changes
        watch = typixLib.watchTypstProject project;
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
      }
    );
}
