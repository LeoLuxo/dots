{ pkgs, hostname, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the new nix cli tool and flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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
