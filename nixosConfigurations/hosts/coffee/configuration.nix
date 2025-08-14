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

      xdgConfig."Ryujinx" = "/stuff/games/emu/switch/ryujinx";
      xdgConfig."steam-rom-manager/userData" = "/stuff/games/emu/steamRomManager/userData";
      xdgData."sudachi" = "/stuff/games/emu/switch/yuzu";
      xdgData."yuzu" = "/stuff/games/emu/switch/yuzu";
    };

    system.pinKernel = enabled;

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
