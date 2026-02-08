{
  pkgs,
  inputs,
  profiles,
  user,
  ...
}:
{
  system.stateVersion = "24.05";

  imports = [
    ./audio.nix
    ./hardware.nix
    ./syncthing.nix
    ./backups.nix
    # ./vr.nix

    inputs.stylix.nixosModules.stylix

    profiles.base
    profiles.pc
    profiles.gaming.base
    profiles.gaming.emulation
    profiles.gaming.minecraft

    profiles.hardware.gpu.amd

    profiles.apps.nicotinePlus
    profiles.apps.beets

    profiles.scripts.bootWindows
  ];

  environment.systemPackages = with pkgs; [
    guitarix # A virtual guitar amplifier for use with Linux.
    qmk
    picard
    audacity
  ];

  # Won't start past login screen
  # TODO: Maybe try again after 25.11 releases
  # stylix = {
  #   enable = true;
  #   base16Scheme = "${pkgs.unstable.base16-schemes}/share/themes/brushtrees-dark.yaml";
  #   polarity = "dark";
  #   autoEnable = false;

  #   targets.gnome.enable = true;
  # };

  # services.ollama = {
  #   enable = true;
  #   acceleration = "rocm";

  #   # Optional: preload models, see https://ollama.com/library
  #   loadModels = [
  #     # "qwen2.5-coder:32b"
  #     # "deepseek-coder:33b"
  #     # "deepseek-r1:32b"
  #   ];
  # };
  # services.open-webui.enable = true;

  wallpaper.image = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/e7/wallhaven-e76pew.png";
    hash = "sha256-x2E24KA8Eilv2pFw2CgskIz1lL2sP9Wqwtb6K2/HtWE=";
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

  pinKernel.enable = true;

  home-manager.users.${user} =
    { lib, user, ... }:
    let
      inherit (lib.hm.gvariant) mkUint32 mkTuple;
    in
    {
      # Enable HDR on my main screen
      dconf.settings = {
        "org/gnome/mutter" = {
          output-luminance = [
            (mkTuple [
              "DP-1"
              "MSI"
              "MAG 274UPF E2"
              "0x00000001"
              (mkUint32 1)
              190.0
            ])
          ];
        };
      };
    };

  gnome = {
    power = {
      buttonAction = "power off";
      confirmShutdown = false;

      screenIdle = {
        enable = true;
        delay = 600;
      };

      suspendIdlePluggedIn.enable = false;
    };

    textScalingPercent = 150;

    cursorSize = 16;

    blur = {
      enable = true;
      # Enable blur for all applications
      # appBlur.enable = true;

      # Set hacks to best looking
      hacksLevel = "no artifact";
    };
  };
}
