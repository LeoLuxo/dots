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

    ./old/backups.nix
    ./old/audio.nix
  ];

  my = {
    user.name = "lili";
    secretManagement = enabled;

    system.pinKernel = enabled;

    desktop.defaultAppsShortcuts = enabled;

    apps = {
      zoxide = enabled;
    };
  };
}
