{ pkgs, ... }:
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  my.packages = [ pkgs.distrobox ];
}
