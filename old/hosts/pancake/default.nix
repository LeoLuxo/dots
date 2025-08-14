{
  lib,
  pkgs,
  lib2,
  ...
}:

let

  inherit (lib2) enabled;
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

    scripts.nx = enabled;

    desktop.defaultAppsShortcuts = enabled;

    system.pinKernel = enabled;

    paths = {
      nixosTodo = "/stuff/obsidian/Notes/NixOS Todo.md";
      nixosRepo = "/etc/nixos/dots";
    };
  };
}
