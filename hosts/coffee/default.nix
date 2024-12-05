{ directories, ... }:
{
  imports = with directories.modules; [
    # Include local modules
    ./hardware.nix
    ./system.nix

    # Include global modules
    autologin

    gnome.gnome

    vscode

    nix-utils
    snip
    terminal-utils
    wl-clipboard

    git
  ];
}
