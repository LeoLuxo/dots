{ ... }:
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
    system = {
      user.name = "lili";
      keys.enable = true;
    };
    nix.secrets.enable = true;
  };
}
