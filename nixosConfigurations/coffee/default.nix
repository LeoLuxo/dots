{ inputs, ... }:
{
  system = "x86_64-linux";

  specialArgs.user = "lili";

  modules = [
    ./configuration.nix
    ./hardwareConfiguration.nix

    inputs.self.nixosModules.default
    { system.stateVersion = "24.05"; }
  ];
}
