{
  description = "My NixOS configuration :)";

  # https://nixos.wiki/wiki/flakes#Flake_schema
  outputs =
    { nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystemPassThrough (
      hostPlatform:

      let
        hosts = import ./hosts.nix;

        # The default pkgs and lib just so I can pass them around where needed
        pkgs = import nixpkgs { inherit hostPlatform; };
        lib = pkgs.lib;

        # My custom libs
        lib2 = import ./lib.nix { inherit lib; };

        args = {
          inherit inputs lib lib2;
          inherit hosts;
        };

        modules = import ./modules args;
        profiles = import ./profiles args;

        overlays = {
          "extraPkgs" = import ./extraPkgs.nix args;
          "builders" = import ./builders.nix args;
        };

        mkNixosConfig =
          {
            nixosConfig,
            nixpkgs ? "nixpkgs",
            hostname,
            users ? { },
            autologin ? null,
            ...
          }@extras:
          # If a `user` is specified, that user must be defined in `users`
          assert !extras ? "user" || users ? ${extras.user};

          inputs.${nixpkgs}.lib.nixosSystem {
            specialArgs = {
              inherit inputs lib2;
              inherit profiles;
              inherit hosts;
              inherit autologin;

              host = hosts.${hostname};
            }
            // extras;

            modules = [
              # Include the main nixos module for this config
              nixosConfig

              # Add our overlays
              {
                nixpkgs.overlays = lib.attrValues overlays;
              }
            ]
            # Auto-include all custom nixos modules
            ++ (lib.attrValues modules);

          };
      in

      {
        # Create nixos configurations for all hosts that have a `nixosConfig`
        nixosConfigurations = lib.concatMapAttrs (
          name: host: if host ? "nixosConfig" then { ${name} = mkNixosConfig host; } else { }
        ) hosts;

        packages.${hostPlatform} = lib.packagesFromDirectoryRecursive {
          inherit (pkgs) callPackage;
          directory = ./packages;
        };
      }
    );

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  inputs = {
    # ----- nixpkgs -------------------------------------------------------------------------------
    "nixpkgs".follows = "nixpkgs-stable";
    "nixpkgs-stable".follows = "nixpkgs-25-11";
    "nixpkgs-unstable".url = "github:nixos/nixpkgs/nixos-unstable";
    "nixpkgs-pinned".url = "github:nixos/nixpkgs/fd487183437963a59ba763c0cc4f27e3447dd6dd";

    "nixpkgs-25-11".url = "github:nixos/nixpkgs/nixos-25.11";
    "nixpkgs-25-05".url = "github:nixos/nixpkgs/nixos-25.05";
    "nixpkgs-24-11".url = "github:nixos/nixpkgs/nixos-24.11";
    "nixpkgs-24-05".url = "github:nixos/nixpkgs/nixos-24.05";

    # ----- personal stuff ------------------------------------------------------------------------
    # My wallpapers
    # Is an external flake to make sure this repo stays small if the wallpapers aren't used
    # (The url MUST use git+ssh otherwise it won't properly authenticate and have access to the private repo)
    wallpapers.url = "git+ssh://git@github.com/chlookie/dots-wallpapers";

    # ----- metaconfig & nix ---------------------------------------------------------------------
    # Manages dotfiles in nix
    home-manager.url = "github:nix-community/home-manager/release-25.11";

    # Provides a set of tools to more easily manage flakes and per-system attrs
    flake-utils.url = "github:numtide/flake-utils";

    # Encryption library, used for secrets in nix
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "home-manager";

    # Automatically sets a theme for basically everything
    stylix.url = "github:nix-community/stylix/release-25.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs-25-05";

    # ----- hardware ------------------------------------------------------------------------------
    # Contains certain nixos hardware settings, notably useful for surface laptops
    # nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nixos-hardware.url = "github:8bitbuddhist/nixos-hardware/surface-kernel-6.18";

    # Real-time audio in NixOS
    musnix.url = "github:musnix/musnix";

    # ----- other ---------------------------------------------------------------------------------
    # Pre-built database for nix-index, which is an index of which files are provided by which packages
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # A wrapper for the nix commands that pipes everything through nix-output-monitor
    nix-monitored.url = "github:ners/nix-monitored";
  };

}
