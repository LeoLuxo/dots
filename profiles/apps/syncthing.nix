{ ... }:
{
  # Open the firewall ports for syncthing
  networking.firewall = {
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [
      21027
      22000
    ];
  };

  # Do nothing else, let the home-manager module take care of the rest instead
}
