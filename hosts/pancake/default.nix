{
  ...
}:
{
  # Include local modules
  imports = [
    ./software.nix
    ./hardware.nix
    ./system.nix
    ./syncthing.nix

    ./wifi.nix
  ];
}
