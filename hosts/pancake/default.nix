{
  pkgs,
  nixos-hardware,
  agenix,
  directories,
  user,
  ...
}:
{
  imports = with directories.modules; [
    # Include global modules
    style.bootscreen
    style.fonts
    style.static-wallpapers
    style.themes.catppuccin

    gnome.gnome
    gnome.extensions.blur-my-shell
    gnome.extensions.clipboard
    gnome.extensions.gsconnect
    gnome.extensions.just-perfection
    gnome.extensions.rounded-corners
    # gnome.extensions.emojis
    # gnome.extensions.weather

    # terminals.guake
    terminals.ddterm

    # translation.deepl
    translation.gnome-dialect

    snip

    obsidian
    discord
    vscode
    git
    steam

    # Include local modules
    ./syncthing.nix
    ./wifi.nix

    # Include hardware config
    ./hardware-configuration.nix

    # Include hardware stuff and kernel patches for surface pro 7
    nixos-hardware.nixosModules.microsoft-surface-pro-intel
  ];

  # Home-Manager config
  home-manager.users.${user} = {

    # Extra packages that don't necessarily need an entire dedicated module
    home.packages = with pkgs; [
      bitwarden-desktop

      textpieces
      hieroglyphic

      # Original electron teams package was abandoned
      teams-for-linux
    ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # SD Card
  fileSystems."/stuff" = {
    device = "/dev/disk/by-label/stuff";
    fsType = "btrfs";
  };

  # Set your manual time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  # Use english (Ireland); see: 
  # https://unix.stackexchange.com/questions/62316/why-is-there-no-euro-english-locale
  i18n.defaultLocale = "en_IE.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # Enable and configure the X11 windowing system.
  services.xserver = {
    enable = true;

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "altgr-intl";
    };

    # Touchscreen support
    modules = [ pkgs.xf86_input_wacom ];
    wacom.enable = true;
  };

  # Also for touchscreen support (or maybe touchpad? unsure)
  services.libinput.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # System programs
  programs = {
    # Install firefox.
    firefox.enable = true;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    nano
    wget

    # Still include git globally even if home-manager takes care of its config
    git

    # Install agenix CLI
    agenix.packages.${system}.default
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
