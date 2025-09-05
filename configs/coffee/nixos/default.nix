{ nixosProfiles, ... }:
{
  imports = [
    ./hardware.nix

    nixosProfiles.pc
    nixosProfiles.gpu.amd
  ];

  system.stateVersion = "24.05";

  pinKernel = {
    enable = true;
  };
}
