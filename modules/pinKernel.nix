{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) types;
  inherit (lib.options) mkOption;

  cfg = config.pinKernel;
  pinnedPkgs = pkgs."25-05";
in
{
  options.pinKernel = {
    enable = lib.mkEnableOption "pinning the linux kernel to a specific version";

    version = mkOption {
      description = "the version of the kernel to pin to";
      type = types.str;
      default = "6.12.36"; # current longterm support
    };

    hash = mkOption {
      description = "the sha256 hash of the kernel source archive";
      type = types.str;
      default = "sha256-ShaK7S3lqBqt2QuisVOGCpjZm/w0ZRk24X8Y5U8Buow=";
    };
  };

  config = lib.mkIf cfg.enable (
    let
      v = lib.splitVersion cfg.version;
      major = lib.elemAt v 0;
      minor = lib.elemAt v 1;
      # patch = lib.elemAt v 2;

      package = "linux_${major}_${minor}";
    in
    {
      boot.kernelPackages = pinnedPkgs.linuxPackagesFor (
        pinnedPkgs.${package}.override {
          argsOverride = {
            src = pinnedPkgs.fetchurl {
              url = "mirror://kernel/linux/kernel/v${major}.x/linux-${cfg.version}.tar.xz";
              sha256 = cfg.hash;
            };
            version = cfg.version;
            modDirVersion = cfg.version;
          };
        }
      );
    }
  );
}
