{ lib, ... }:

let

  inherit (lib.my) enabled;
in
{
  # Include local modules
  imports = [
    ./audio.nix

    ./old/software.nix
    ./old/hardware.nix
    ./old/system.nix
    ./old/syncthing.nix
    ./old/backups.nix
  ];

  my = {
    user.name = "lili";
    secretManagement = enabled;

    symlinks = {
      enable = true;

      xdgConfig."Ryujinx" = "/stuff/games/roms/switch/data/ryujinx";
      xdgConfig."steam-rom-manager/userData" = "/stuff/games/roms/.srm/userData";
      xdgData."sudachi" = "/stuff/games/roms/switch/data/yuzu";
      xdgData."yuzu" = "/stuff/games/roms/switch/data/yuzu";
    };

    nx = enabled;

    system.pinKernel = enabled;

    desktop.defaultAppsShortcuts = enabled;

    apps = {
      zoxide = enabled;
    };

    paths = {
      nixosTodo = "/stuff/obsidian/Notes/NixOS Todo.md";
      nixosRepo = "/etc/nixos/dots";
    };
  };

  boot.kernelModules = [
    "hid_sony"
    "hid_playstation"
  ];
}
