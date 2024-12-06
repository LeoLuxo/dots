{
  user,
  directories,
  pkgs,
  ...
}:
{
  imports = with directories.modules; [
    # Include local modules
    ./hardware.nix
    ./system.nix
    ./syncthing.nix

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
    gnome.extensions.system-monitor
    # gnome.extensions.emojis
    # gnome.extensions.weather

    terminal.ddterm
    shell.prompt.starship
    shell.bash
    shell.fish
    # shell.nushell

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
    qmk
  ];

  # Home-Manager config
  home-manager.users.${user} = {

    # Extra packages that don't necessarily need an entire dedicated module
    home.packages = with pkgs; [
      bitwarden-desktop

      textpieces
      hieroglyphic

      teams-for-linux
    ];
  };

  # Set wallpaper  
  wallpaper = {
    enable = true;
    image = directories.wallpapers."Riverside";
  };

  # Set default shell
  shell.default = "fish";

  gnome.blur-my-shell = {

    # Enable blur for all applications
    app-blur.enable = true;

    # Set hacks to 1
    hacks-level = "no artifact";
  };
}
