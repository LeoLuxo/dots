{
  pkgs,
  directories,
  user,
  ...
}:
{
  imports = with directories.modules; [
    # Include local modules
    ./hardware.nix
    ./syncthing.nix
    ./wifi.nix

    # Include global modules
    style.bootscreen
    style.fonts
    style.wallpapers
    style.themes.catppuccin

    gnome.gnome
    gnome.extensions.blur-my-shell
    gnome.extensions.clipboard
    gnome.extensions.gsconnect
    gnome.extensions.just-perfection
    gnome.extensions.rounded-corners
    # gnome.extensions.emojis
    # gnome.extensions.weather

    terminal.ddterm
    shell.prompt.starship
    shell.bash
    shell.fish
    # shell.nushell

    # translation.deepl
    translation.gnome-dialect

    nix-utils
    snip
    terminal-utils
    wl-clipboard

    obsidian
    firefox
    discord
    vscode
    git
    steam
  ];

  # Set wallpaper  
  wallpaper = {
    enable = true;
    image = directories.wallpapers."Tree and shore";
  };

  # Set default shell
  shell.default = "fish";

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
