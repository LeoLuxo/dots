{ nixosProfiles, ... }:
{
  imports = [
    nixosProfiles.base
    nixosProfiles.gpu.amd
  ];

  pinKernel = {
    enable = true;
  };
}
