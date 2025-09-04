{ nixosProfiles, ... }:
{
  imports = [
    ./hardware.nix

    nixosProfiles.base
    nixosProfiles.gpu.amd
  ];

  system.stateVersion = "24.05";

  pinKernel = {
    enable = true;
  };
}
