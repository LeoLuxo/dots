{ pkgs, ... }:
{
  # A client for the Soulseek peer-to-peer file sharing network.
  environment.systemPackages = [
    pkgs.nicotine-plus
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 2234 ];
  };
}
