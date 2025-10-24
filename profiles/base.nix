{
  hostname,
  lib,
  pkgs,
  profiles,
  users,
  ...
}:
{
  imports = [
    profiles.agenix
  ];

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    # Enable the new nix cli tool and flakes
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # A list of names of users that have additional rights when connecting to the Nix daemon, such as the ability to specify additional binary caches, or to import unsigned NARs.
    trusted-users =
      [
        "root"
      ]
      # Add all manually-defined users
      ++ (lib.mapAttrsToList (username: _: username) users);
  };

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
