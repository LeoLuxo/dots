{
  profiles,
  inputs,
  pkgs,
  ...
}:
{
  system.stateVersion = "24.05";

  imports = [
    ./hardware.nix
    ./syncthing.nix

    # Include hardware stuff and kernel patches for surface pro 7
    inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel

    profiles.base
    profiles.pc
    profiles.wifi
    profiles.gaming.base

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

  gnome = {
    power = {
      buttonAction = "suspend";
      confirmShutdown = true;

      screenIdle = {
        enable = true;
        delay = 600;
      };

      suspendIdlePluggedIn = {
        enable = true;
        delay = 900;
      };

      suspendIdleOnBattery = {
        enable = true;
        delay = 600;
      };

    };

    cursorSize = 32;
  };

  # Enable sound with pipewire.
  # services.pulseaudio.enable = false;
  # security.rtkit.enable = true;
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  #   # If you want to use JACK applications, uncomment this
  #   #jack.enable = true;

  #   # use the example session manager (no others are packaged yet so this is enabled by default,
  #   # no need to redefine it in your config for now)
  #   #media-session.enable = true;
  # };
}
