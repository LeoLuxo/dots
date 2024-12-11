{
  pkgs,
  directories,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  # Include global modules
  imports = with directories.modules; [
    styling

    gnome.gnome
    gnome.extensions.blur-my-shell
    gnome.extensions.clipboard
    gnome.extensions.gsconnect
    gnome.extensions.just-perfection
    gnome.extensions.rounded-corners
    # gnome.extensions.emojis
    # gnome.extensions.weather
    gnome.extensions.system-monitor
    gnome.extensions.burn-my-windows

    terminal.ddterm
    shell.bash
    shell.fish
    # shell.nushell
    shell.prompt.starship

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
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      bitwarden-desktop
      textpieces
      hieroglyphic
      teams-for-linux
      guitarix
      r2modman
    ];
  };

  styling = {
    wallpaper = {
      enable = true;
      image = directories.wallpapers."Earth";
    };

    theme = {
      enable = true;
      name = "catppuccin";
      flavor = "frappe";
      accent = "blue";
    };

    cursor = {
      enable = true;
      name = "catppuccin";
      flavor = "frappe";
      accent = "dark";
    };

    bootscreen.enable = true;
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
