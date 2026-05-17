{
  profiles,
  inputs,
  pkgs,
  ...
}@args:
{
  system.stateVersion = "24.05";

  imports = [
    ./hardware.nix
    ./syncthing.nix

    # Include hardware stuff and kernel patches for surface pro 7
    # IMPORTANT: Am manually giving the arguments so that I can override the pkgs instance it uses to the pinned one, to avoid recompiling the kernel at every nixpkgs update
    (import inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel (
      args // { pkgs = pkgs.pinned; }
    ))

    profiles.base
    profiles.pc
    profiles.wifi
    profiles.gaming.base
  ];

  environment.systemPackages = [
    inputs.winapps.packages.${pkgs.stdenv.hostPlatform.system}.winapps
    inputs.winapps.packages.${pkgs.stdenv.hostPlatform.system}.winapps-launcher
    pkgs.wineWow64Packages.stable
    # pkgs.wineWow64Packages.stagingFull
    pkgs.bottles
    pkgs.winetricks
    pkgs.samba
  ];

  wallpaper.image = inputs.wallpapers.dynamic."treeAndShore";

  # Fixes blurry electron apps
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  # Pin the kernel with nixos-hardware
  hardware.microsoft-surface.kernelVersion = "longterm";
  # hardware.microsoft-surface.kernelVersion = "stable";

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

    accentColor = "orange";

    cursorSize = 32;

    lockscreen = {
      wallpaper = inputs.wallpapers.static.iridescentGlass;
      blur = 10;
      darken = 35;
    };
  };
}
