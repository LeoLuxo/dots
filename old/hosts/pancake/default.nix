{ lib, ... }:

let

  inherit (lib.my) enabled;
in
{
  # Include local modules
  imports = [
    ./old/software.nix
    ./old/hardware.nix
    ./old/system.nix
    ./old/syncthing.nix

    ./old/wifi.nix
  ];

  my = {
    user.name = "lili";
    secretManagement = enabled;
    symlinks = enabled;

    nx = enabled;

    desktop.defaultAppsShortcuts = enabled;

    system.pinKernel = enabled;

    paths = {
      nixosTodo = "/stuff/obsidian/Notes/NixOS Todo.md";
      nixosRepo = "/etc/nixos/dots";
    };
  };
}
