{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.my.system.pinKernel;
in
{
  options.my.system.pinKernel = {
    enable = lib.mkEnableOption "pinning the linux kernel to a specific version";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelPackages = pkgs.linuxPackagesFor (
      pkgs.linux_6_12.override {
        argsOverride = rec {
          src = pkgs.fetchurl {
            url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
            sha256 = "";
          };
          version = "6.12.19";
          modDirVersion = "6.12.19";
        };
      }
    );
  };
}
