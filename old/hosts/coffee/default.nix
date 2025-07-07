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
    symlinks = enabled;

    system.pinKernel = enabled;

    desktop.defaultAppsShortcuts = enabled;

    apps = {
      zoxide = enabled;
    };
  };
}
