{
  pkgs,
  hostname,
  ...
}:
{
  # Networking
  networking = {
    # Define hostname.
    hostName = hostname;
  };

  # Essential system packages
  environment.systemPackages = with pkgs; [
    nano
    wget
    curl
    git
  ];
}
