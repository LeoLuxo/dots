{
  hostname,
  config,
  hosts,
  lib,
  pkgs,
  profiles,
  users,
  autologin,
  ...
}:

let
  defaultShell = "fish";
in
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

  # Set the hostname
  networking.hostName = hostname;

  # Add all IPs defined in my hosts list to the networking hosts map
  networking.hosts = lib.concatMapAttrs (
    name: hostCfg:
    lib.concatMapAttrs (_: ip: {
      "${ip}" = [ name ];
    }) (hostCfg.ip or { })
  ) hosts;

  # Define and set up all the manually-defined users
  users = {
    mutableUsers = false;

    users = lib.concatMapAttrs (username: userCfg: {
      ${username} = {
        home = "/home/${username}";
        description = username;
        isNormalUser = true;

        hashedPasswordFile = config.age.secrets."userpwds/${hostname}/${username}".path;
        extraGroups = [ "wheel" ];

        uid = userCfg.uid;

        # Set default shell (can't be done in home-manager afaik)
        shell = pkgs.${defaultShell};
      };
    }) users;
  };

  # # Install default shell
  programs.${defaultShell}.enable = true;

  # # Enable autologin if relevant
  services.displayManager.autoLogin = lib.mkIf (autologin != null) {
    enable = true;
    user = autologin;
  };

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # Set the time zone.
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

  # The keyboard mapping table for the virtual consoles
  console.keyMap = "us";

  # Essential system packages
  environment.systemPackages = with pkgs; [
    nano
    wget
    curl
    git
  ];
}
