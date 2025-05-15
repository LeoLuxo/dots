{ inputs, ... }:
{
  system = "x86_64-linux";

  modules = [
    # ./configuration.nix
    # ./audio.nix
    # ./hardwareConfiguration.nix

    inputs.self.nixosModules.default

    { system.stateVersion = "24.05"; }
  ];
}
