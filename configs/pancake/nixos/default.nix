{ ... }:
{
  imports = [
    ./configuration.nix
    ./hardware.nix
  ];

  system.stateVersion = "24.05";
}
