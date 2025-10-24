{
  profiles,
  pkgs,
  hostname,
  ...
}:
{
  imports = [
    profiles.agenix
  ];

  # Set the hostname
  networking.hostName = hostname;

  # Essential system packages
  environment.systemPackages = with pkgs; [
    nano
    wget
    curl
    git
  ];
}
