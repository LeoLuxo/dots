{
  pkgs,
  config,
  inputs,
  user,
  hostname,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    # Essential system packages
    nano
    wget
    curl
    git

    # Install agenix CLI
    inputs.agenix.packages.${config.nixpkgs.hostPlatform}.default
  ];

  # Set the hostname
  networking.hostName = hostname;

  # Enable boot loading
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # Define the default user account.
  users = {
    mutableUsers = false;

    users.${user} = {
      home = "/home/user";
      description = "the default user '${user}'";
      isNormalUser = true;

      hashedPasswordFile = config.age.secrets."userpws/${hostname}".path;
      extraGroups = [ "wheel" ];

      # Not setting the uid will make it choose one that's available
      # uid = 1000;
    };
  };

  nix.settings = {
    trusted-users = [
      user
    ];
  };

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # Handle agenix secrets
  imports = [
    # Include agenix module
    inputs.agenix.nixosModules.default
  ];

  age = {
    # Use the special agenix key
    identityPaths = [
      "/etc/ssh/agenix_ed25519"
    ];

    # Add secrets from the flake to agenix config
    secrets =
      let
        # Fetch secrets from private repo
        # Secrets are SUPPOSED to be fully independent from the dots in my opinion, thus this (intentionally) makes my dots impure
        # (note to self: the url MUST use git+ssh otherwise it won't properly authenticate and have access to the repo)
        flake = builtins.getFlake "git+ssh://git@github.com/LeoLuxo/nix-secrets";
      in
      flake.ageSecrets;
  };

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # Set the time zone and locale
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  # A good choice would also be english-(Ireland); see:
  # https://unix.stackexchange.com/questions/62316/why-is-there-no-euro-english-locale
  i18n.defaultLocale = "en_DK.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "en_IE.UTF-8";
    # LC_ADDRESS = "en_IE.UTF-8";
    # LC_IDENTIFICATION = "en_IE.UTF-8";
    # LC_MEASUREMENT = "en_IE.UTF-8";
    # LC_MONETARY = "en_IE.UTF-8";
    # LC_NAME = "en_IE.UTF-8";
    # LC_NUMERIC = "en_IE.UTF-8";
    # LC_PAPER = "en_IE.UTF-8";
    # LC_TELEPHONE = "en_IE.UTF-8";
  };

}
