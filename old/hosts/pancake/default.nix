{ ... }:
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

    system.user.name = "lili";

    nix.secrets.enable = true;
  };
}
