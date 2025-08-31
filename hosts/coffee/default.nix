{ mkHost, ... }:

mkHost {
  hostname = "coffee";
  user = "lili";

  nixosModules = [
    ./nixos/configuration.nix
    ./nixos/hardware.nix

    {
      system.stateVersion = "24.05";
    }
  ];

  homeModules = [
    ./home.nix
  ];
}
