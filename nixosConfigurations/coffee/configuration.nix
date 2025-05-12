{
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib2) enabled;
in
{
  ext = {
    suites.pc.desktop = {
      enable = true;
      username = "lili";
    };

    hardware.gpu.nvidia = enabled;

    keyboard = {
      layout = "us";
      variant = "altgr-intl";
    };

    scripts.bootWindows = enabled;
  };

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
}
