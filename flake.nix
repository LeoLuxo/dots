{
  description = "Home Manager configuration of pancake";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    { nixpkgs, ... }@inputs:
    {
      # Enable the new nix cli tool and flakes
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      nixosConfigurations = {
        "pancake" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/pancake
          ];
          specialArgs = inputs;
        };
      };
    };
}
