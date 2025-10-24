{
  pkgs,
  inputs,
  profiles,
  ...
}:
{
  system.stateVersion = "24.05";

  imports = [
    # TODO: remove
    (import "${inputs.self}/_old/nixosConfigurations/coffee")

    ./audio.nix
    ./hardware.nix
    ./syncthing.nix
    # ./backups.nix

    profiles.base
    profiles.pc
    # profiles.personal
    # profiles.music
    # profiles.gaming.base
    # profiles.gaming.emulation
    # profiles.gaming.minecraft
    # profiles.gpu.amd

    # profiles.apps.nicotinePlus
    # profiles.apps.qmk
    # profiles.apps.syncthing
    profiles.apps.ukmm
    profiles.apps.wiiuDownloader

    # profiles.scripts.bootWindows

    # pkgs.wiiuDownloader
    # (pkgs.callPackage "${inputs.self}/packages/yuzu.nix" { })
    # customPkgs.ukmm
  ];

  services.ollama = {
    enable = true;
    acceleration = "rocm";

    # Optional: preload models, see https://ollama.com/library
    loadModels = [
      # "qwen2.5-coder:32b"
      # "deepseek-coder:33b"
      # "deepseek-r1:32b"
    ];
  };
  # services.open-webui.enable = true;

  environment.systemPackages = [
    pkgs.guitarix # A virtual guitar amplifier for use with Linux.
  ];

  wallpaper.image = inputs.wallpapers.dynamic."treeAndShore";

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

  pinKernel = {
    enable = true;
  };

  # gnome = {
  #   power = {
  #     buttonAction = "power off";
  #     confirmShutdown = false;

  #     screenIdle = {
  #       enable = true;
  #       delay = 600;
  #     };

  #     suspendIdlePluggedIn.enable = false;
  #   };

  #   textScalingPercent = 150;

  #   cursorSize = 16;

  #   blur = {
  #     enable = true;
  #     # Enable blur for all applications
  #     # appBlur.enable = true;

  #     # Set hacks to best looking
  #     hacksLevel = "no artifact";
  #   };
  # };
}
