{ directories, ... }:
{
  imports = with directories.modules; [
    # Include local modules
    ./hardware.nix
    ./system.nix

    # Include global modules
    autologin

    gnome.gnome

    nix-utils
    snip
    terminal-utils
    wl-clipboard

    firefox
    git
    vscode
  ];
}
