{ inputs, nixosProfiles, ... }:
{
  imports = [
    ./hardware.nix

    # Include hardware stuff and kernel patches for surface pro 7
    inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel

    nixosProfiles.base
    nixosProfiles.wifi

    nixosProfiles.apps.syncthing
  ];

  system.stateVersion = "24.05";
}
