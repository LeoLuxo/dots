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
    system = {
      user.name = "lili";
      keys.enable = true;
    };
    nix.secrets.enable = true;
    desktop.defaultAppsShortcuts.enable = true;
  };
}
