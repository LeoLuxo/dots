{
  profiles,
  inputs,
  pkgs,
  ...
}:
{
  system.stateVersion = "24.05";

  imports = [
    # TODO: remove
    (import "${inputs.self}/_old/nixosConfigurations/pancake")

    ./hardware.nix
    ./syncthing.nix

    # Include hardware stuff and kernel patches for surface pro 7
    inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel

    profiles.base
    profiles.pc
    # profiles.gaming
    profiles.wifi

    # profiles.apps.syncthing
  ];

  wallpaper.image = inputs.wallpapers.dynamic."treeAndShore";

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

  # gnome = {
  #   power = {
  #     buttonAction = "suspend";
  #     confirmShutdown = true;

  #     screenIdle = {
  #       enable = true;
  #       delay = 600;
  #     };

  #     suspendIdlePluggedIn = {
  #       enable = true;
  #       delay = 900;
  #     };

  #     suspendIdleOnBattery = {
  #       enable = true;
  #       delay = 600;
  #     };

  #     cursorSize = 32;
  #   };
  # };
}
