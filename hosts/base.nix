{
  config,
  pkgs,
  home-manager,
  constants,
  directories,
  ...
}:

let
  inherit (constants) user userHome hostName;
in

{
  imports = [
    # Include home manager module
    home-manager.nixosModules.home-manager

    directories.modules.defaults
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

    # On activation move existing files by appending the given file extension rather than exiting with an error.
    # Applies to home.file and also xdg.*File
    backupFileExtension = "bak";

    users.${user} = {
      # Do not change
      home.stateVersion = "24.05";

      # Home Manager needs a bit of information about you and the paths it should manage.
      home.username = user;
      home.homeDirectory = userHome;

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
  };

  # Define default user account.
  users = {
    mutableUsers = false;

    users.${user} = {
      home = userHome;
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
  ];

  # Networking
  networking = {
    # Define hostname.
    inherit hostName;
  };
}
