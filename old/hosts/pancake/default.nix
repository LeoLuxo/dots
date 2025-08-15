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
    secretManagement = {
      enable = true;

      editSecretsCommand = {
        enable = true;
        path = "/etc/nixos/secrets";
      };
    };
    symlinks = enabled;

    scripts.nx = enabled;

    desktop.defaultAppsShortcuts = enabled;

    # system.pinKernel = enabled;

    paths = {
      nixosTodo = "/stuff/obsidian/Notes/NixOS Todo.md";
      nixosRepo = "/etc/nixos/dots";
    };
  };

  hardware.microsoft-surface.kernelVersion = "longterm";
}
