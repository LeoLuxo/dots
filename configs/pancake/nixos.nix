{ inputs, nixosProfiles, ... }:
{
  imports = [
    ./hardware.nix

    nixosProfiles.base
    nixosProfiles.wifi

    # Include hardware stuff and kernel patches for surface pro 7
    inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
  ];

  system.stateVersion = "24.05";
}
