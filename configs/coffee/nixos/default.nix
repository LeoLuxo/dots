{ nixosProfiles, ... }:
{
  imports = [
    ./hardware.nix
    ./audio.nix

    nixosProfiles.pc
    nixosProfiles.gpu.amd

    nixosProfiles.apps.nicotinePlus
    nixosProfiles.apps.qmk
    nixosProfiles.apps.syncthing
  ];

  system.stateVersion = "24.05";

  pinKernel = {
    enable = true;
  };

}
