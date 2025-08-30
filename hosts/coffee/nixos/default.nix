{ inputs, lib2, ... }:
inputs.nixpkgs.lib.nixosSystem ({
  modules = [
    ./hardwareConfiguration.nix

    {
      nixpkgs.overlays = [
        inputs.self.overlays.pkgs
        inputs.self.overlays.builders
      ];

      system.stateVersion = "24.05";
    }
  ];

  # Additional args passed to the modules
  specialArgs = {
    inherit inputs lib2;
    inherit (inputs.self) nixosModules;

    hostname = "coffee";
    user = "lili";
  };
})
