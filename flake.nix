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
    let
      # Evaluate the root path right here, right now. This forces it to be the current path of the flake (in the nix store ofc) instead of being evaluated down the line in a module
      # rootPath = "${./.}";

      # Some helper paths to avoid using relative paths
      modulesPath = ./modules;
      hostModulesPath = ./modules/host;
      userModulesPath = ./modules/user;
      scriptsPath = ./scripts;

      #
      getInlineSecret =
        name:
        builtins.exec [
          "nix"
          "run"
          "github:ryantm/agenix"
          "--"
          "--decrypt"
          "/etc/nixos/secrets/${name}.age"
        ];

      # Function to create a nixos config
      mkConfig = (
        system: module:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            module
            inputs.agenix.nixosModules.default
            ./modules/host/secrets.nix
          ];
          specialArgs = inputs // {
            inherit
              system
              modulesPath
              hostModulesPath
              userModulesPath
              scriptsPath
              getInlineSecret
              ;
          };
        }
      );
    in
    {
      # Dummy config to force agenix to decrypt secrets.
      # Intended to be run with
      # nixos-rebuild test
      # before doing the proper nixos-rebuild switch with the real config
      # nixosConfigurations."_decryptSecrets" = nixpkgs.lib.nixosSystem {
      #   system = builtins.currentSystem;
      #   modules = [
      #     inputs.agenix.nixosModules.default
      #     ./modules/host/secrets.nix
      #   ];
      #   specialArgs = inputs;
      # };

      # Define nixos host configs
      nixosConfigurations = {

        # Laptop (Surface Pro 7)
        "pancake" = mkConfig "x86_64-linux" ./hosts/pancake;

      };
    };
}
