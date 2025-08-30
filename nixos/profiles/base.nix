{
  pkgs,
  config,
  user,
  hostname,
  ...
}:
{
  imports = [
    ./agenix.nix
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
    trusted-users = [
      "root"
      user
    ];
  };

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # Essential system packages
  environment.systemPackages = with pkgs; [
    nano
    wget
    curl
    git
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

      hashedPasswordFile = config.age.secrets."userpwds/${hostname}".path;
      extraGroups = [ "wheel" ];

      # Not setting the uid will make it choose one that's available
      # uid = 1000;
    };
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
