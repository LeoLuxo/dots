{
  config,
  pkgs,
  home-manager,
  agenix,
  system,
  user,
  hostName,
  scriptBin,
  ...
}:
{
  imports = [
    # Include home manager module
    home-manager.nixosModules.home-manager
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the new nix cli tool and flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Home-Manager config
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${user} = {
      # Do not change
      home.stateVersion = "24.05";

      # Home Manager needs a bit of information about you and the paths it should manage.
      home.username = user;
      home.homeDirectory = "/home/${user}";

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      home.packages = [
        # Install agenix CLI
        agenix.packages.${system}.default
      ];
    };
  };

  # Define default user account.
  users = {
    mutableUsers = false;

    users.${user} = {
      description = user;
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets."userpwds/${hostName}".path;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };

  # Base system packages
  environment.systemPackages = with pkgs; [
    nano
    wget

    # Still include git globally even if home-manager takes care of its config
    git

    # Rebuild script
    scriptBin.rebuild
  ];

  # Networking
  networking = {
    # Define hostname.
    inherit hostName;
  };
}
