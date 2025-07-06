{ inputs, ... }:

let
  lib2 = inputs.self.lib;
  inherit (lib2) enabled;
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

    apps = {
      zoxide = enabled;
    };
  };
}
