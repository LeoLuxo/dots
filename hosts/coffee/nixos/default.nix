{ inputs, lib2, ... }:

inputs.nixpkgs.lib.nixosSystem ({
  # Additional args passed to the modules
  specialArgs = {
    inherit inputs lib2;
    inherit (inputs.self) nixosModules nixosProfiles;

    hostname = "coffee";
    user = "lili";
  };

  modules = [
    ./configuration.nix
    ./hardwareConfiguration.nix

    {
      nixpkgs.overlays = [
        inputs.self.overlays.pkgs
        inputs.self.overlays.builders
      ];

      system.stateVersion = "24.05";
    }
  ];
})
