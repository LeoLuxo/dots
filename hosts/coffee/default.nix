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

    # Include global modules

    autologin

    # style.bootscreen
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
    ];
  };
}
