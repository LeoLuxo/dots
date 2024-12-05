# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ directories, ... }:
{
  imports = with directories.modules; [
    # Include local modules
    ./hardware.nix
    ./system.nix
    ./syncthing.nix
    ./wifi.nix

    # Include global modules
    autologin

    gnome.gnome
  ];
}
