{ inputs, ... }:
{
  system = "x86_64-linux";

  modules = [
    # ./configuration.nix
    # ./hardwareConfiguration.nix

    # inputs.self.nixosModules.default
    # inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel

    { system.stateVersion = "24.05"; }
  ];
}
