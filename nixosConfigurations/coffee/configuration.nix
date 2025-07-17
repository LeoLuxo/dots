{
  lib,
  ...
}:

let
  inherit (lib.my) enabled;
in
{
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

  my = {
    suites.pc.desktop = enabled // {
      username = "lili";
    };

    secretManagement = {
      enable = true;

      editSecretsCommand = {
        enable = true;
        path = "/etc/nixos/secrets";
      };
    };

    symlinks = {
      enable = true;

      xdgConfig."Ryujinx" = "/stuff/games/roms/switch/data/ryujinx";
      xdgConfig."steam-rom-manager/userData" = "/stuff/games/roms/.srm/userData";
      xdgData."sudachi" = "/stuff/games/roms/switch/data/yuzu";
      xdgData."yuzu" = "/stuff/games/roms/switch/data/yuzu";
    };

    # system.pinKernel = enabled;

    desktop.defaultAppsShortcuts = enabled;

    apps = {
      zoxide = enabled;
    };

    paths = {
      nixosTodo = "/stuff/obsidian/Notes/NixOS Todo.md";
      nixosRepo = "/etc/nixos/dots";
    };

    hardware.gpu.amd = enabled;
    hardware.controller.playstation = enabled;
  };

}
