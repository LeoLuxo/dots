{
  inputs,
  nixosProfiles,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware.nix

    # Include hardware stuff and kernel patches for surface pro 7
    inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel

    nixosProfiles.base
    nixosProfiles.wifi

    nixosProfiles.apps.syncthing
  ];

  # Pin the kernel with nixos-hardware
  hardware.microsoft-surface.kernelVersion = "longterm";

  # SD Card
  fileSystems."/stuff" = {
    device = "/dev/disk/by-label/stuff";
    fsType = "btrfs";
  };

  # Touchscreen support
  services.xserver = {
    modules = [ pkgs.xf86_input_wacom ];
    wacom.enable = true;
  };

  # Also for touchscreen support (or maybe touchpad? unsure)
  services.libinput.enable = true;

  system.stateVersion = "24.05";
}
