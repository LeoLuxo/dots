{
  user,
  directories,
  pkgs,
  ...
}:
{
  # Include global modules
  imports = with directories.modules; [
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
    gnome.extensions.burn-my-windows

    terminal.ddterm
    shell.prompt.starship
    shell.bash
    shell.fish
    # shell.nushell

    nix-utils
    snip
    terminal-utils
    wl-clipboard
    boot-windows

    obsidian
    firefox
    discord
    vscode
    git
    steam
    qmk
  ];

  # Extra packages that don't necessarily need an entire dedicated module
  home-manager.users.${user}.home.packages = with pkgs; [
    bitwarden-desktop

    textpieces
    hieroglyphic

    teams-for-linux

    guitarix
  ];

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
