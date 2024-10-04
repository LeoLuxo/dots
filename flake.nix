{
  description = "My Nix configuration :)";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Contains certain nixos hardware settings, specifically for surface laptops
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    # Manages dotfiles in nix
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Encryption thingie, used for secrets in nix
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      # optionally choose not to download darwin deps (saves some resources on Linux)
      inputs.darwin.follows = "";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:

    with nixpkgs.lib;

    let
      findModules =
        dir:
        builtins.concatLists (
          builtins.attrValues (
            builtins.mapAttrs (
              name: type:
              if type == "regular" then
                [
                  {
                    name = builtins.elemAt (builtins.match "(.*)\\.nix" name) 0;
                    value = dir + "/${name}";
                  }
                ]
              else if (builtins.readDir (dir + "/${name}")) ? "default.nix" then
                [
                  {
                    inherit name;
                    value = dir + "/${name}";
                  }
                ]
              else
                findModules (dir + "/${name}")
            ) (builtins.readDir dir)
          )
        );

      globalModules = traceValSeq (builtins.listToAttrs (traceValSeq (findModules ./modules)));

      extraInputs = inputs // {
        inherit
          user
          system
          globalModules
          mkHost
          ;
      };

      # Function to create a nixos host config
      mkHost = (
        {
          user,
          system,
          hostModule,
        }:
        nixosSystem {
          inherit system;
          modules = [
            hostModule
            ./secrets.nix
          ];
          specialArgs = extraInputs;
        }
      );

    in
    {
      # Define nixos configs
      nixosConfigurations = import ./hosts.nix extraInputs;
    };
}
