{ lib, ... }:

let

  inherit (lib.my) enabled;
in
{
  # Include local modules
  imports = [
    ./software.nix
    ./hardware.nix
    ./system.nix
    ./syncthing.nix

    ./wifi.nix
  ];

  my = {
    user.name = "lili";
    secretManagement = enabled;

    desktop.defaultAppsShortcuts = enabled;

    system.pinKernel = enabled;
  };
}
