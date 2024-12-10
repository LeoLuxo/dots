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
    ./system.nix
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

  # Extra packages that don't necessarily need an entire dedicated module
  home-manager.users.${user}.home.packages = with pkgs; [
    bitwarden-desktop

    textpieces
    hieroglyphic

    # Original electron teams package was abandoned
    teams-for-linux
  ];

}
