{ pkgs, ... }:
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  ext.packages = [ pkgs.distrobox ];
}
