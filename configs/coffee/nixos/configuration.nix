{ nixosProfiles, ... }:
{
  imports = [
    nixosProfiles.base
  ];

  pinKernel = {
    enable = true;
  };
}
