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

    desktop.gnome.gnome
    desktop.gnome.extensions.blur-my-shell
    desktop.gnome.extensions.clipboard-indicator
    desktop.gnome.extensions.gsconnect
    desktop.gnome.extensions.rounded-corners
    # desktop.gnome.extensions.emojis
    # desktop.gnome.extensions.weather
    desktop.gnome.extensions.system-monitor
    desktop.gnome.extensions.media-controls
    desktop.gnome.extensions.burn-my-windows

    terminal.ddterm
    shell.bash
    shell.fish
    # shell.nushell
    shell.prompt.starship

    scripts.nix-utils
    scripts.snip
    scripts.terminal-utils
    scripts.clipboard
    scripts.boot-windows

    apps.youtube-music
    apps.obsidian
    apps.firefox
    apps.discord
    apps.vscode
    apps.git
    apps.steam
    apps.qmk
    apps.bitwarden
  ];

  # Extra packages that don't necessarily need an entire dedicated module
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      textpieces
      hieroglyphic
      impression
      switcheroo
      video-trimmer
      warp

      teams-for-linux
      guitarix
      r2modman
      gnome-2048
      muzika
    ];
  };

  styling = {
    wallpaper = {
      enable = true;
      image = directories.wallpapers.dynamic."Outset Island";
    };

    theme = {
      enable = true;
      name = "catppuccin";
      flavor = "frappe";
      accent = "blue";
    };

    cursor = {
      enable = true;
      size = 16;
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

    # Set hacks to best looking
    hacks-level = "no artifact";
  };
}
