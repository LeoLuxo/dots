{ mkHost, ... }:

mkHost {
  hostname = "coffee";
  user = "lili";

  nixosModules = [
    ./nixos/configuration.nix
    ./nixos/hardwareConfiguration.nix

    {
      system.stateVersion = "24.05";
    }
  ];

  homeModules = [
    ./home.nix
  ];
}
