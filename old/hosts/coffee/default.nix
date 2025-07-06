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

    ./backups.nix
    ./audio.nix
  ];

  my = {
    user.name = "lili";
    secretManagement = enabled;

    system.pinKernel = enabled;

    apps = {
      zoxide = enabled;
    };
  };
}
