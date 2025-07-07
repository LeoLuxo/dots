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

    desktop.defaultAppsShortcuts = enabled;

    system.pinKernel = enabled;
  };
}
