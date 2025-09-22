{ profiles, ... }:
{
  imports = [
    ./hardware.nix
    ./audio.nix

    profiles.pc
    profiles.gpu.amd

    profiles.apps.nicotinePlus
    profiles.apps.qmk
    profiles.apps.syncthing
  ];

  # 1TB SSD
  fileSystems."/stuff" = {
    device = "/dev/disk/by-label/stuff";
    fsType = "ext4";
  };

  # 4TB HDD
  fileSystems."/backup" = {
    device = "/dev/disk/by-label/backup";
    fsType = "ntfs";
  };

  system.stateVersion = "24.05";

  pinKernel = {
    enable = true;
  };

}
