{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) types;
  inherit (lib.options) mkOption;

  cfg = config.my.system.pinKernel;
in
{
  options.my.system.pinKernel = {
    enable = lib.mkEnableOption "pinning the linux kernel to a specific version";

    package = mkOption {
      description = "the name of the kernel package to use for pinning";
      type = types.str;
      default = "linux_6_12";
    };

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

  config = lib.mkIf cfg.enable {
    boot.kernelPackages = pkgs.linuxPackagesFor (
      pkgs.${cfg.package}.override {
        argsOverride = {
          src = pkgs.fetchurl {
            url = "mirror://kernel/linux/kernel/v6.x/linux-${cfg.version}.tar.xz";
            sha256 = cfg.hash;
          };
          version = cfg.version;
          modDirVersion = cfg.version;
        };
      }
    );
  };
}
