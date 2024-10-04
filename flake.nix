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

      # Function to create a nixos host config
      mkHost = (
        system: module:
        nixosSystem {
          inherit system;
          modules = [
            module
            ./secrets.nix
          ];
          specialArgs = inputs // {
            inherit system;
            asd = (traceValSeq (findModules ./modules));
            # Some helper paths to avoid using relative paths
            paths = {
              modules = ./modules;
              hostModules = ./modules/host;
              userModules = ./modules/user;
              scripts = ./scripts;
              hosts = ./hosts;
            };
          };
        }
      );
    in
    {
      # Define nixos configs
      nixosConfigurations = {

        # Laptop (Surface Pro 7)
        "pancake" = mkHost "x86_64-linux" ./hosts/pancake;

      };
    };
}
