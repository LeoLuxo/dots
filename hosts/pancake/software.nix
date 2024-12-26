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
    desktop.gnome.extensions.burn-my-windows

    terminal.ddterm
    shell.prompt.starship
    shell.bash
    shell.fish
    # shell.nushell

    scripts.nix-utils
    scripts.snip
    scripts.terminal-utils
    scripts.clipboard

    # apps.deepl
    apps.gnome-dialect
    apps.obsidian
    apps.firefox
    apps.discord
    apps.vscode
    apps.git
    apps.steam
  ];

  styling = {
    wallpaper = {
      enable = true;
      image = directories.wallpapers.dynamic."Tree and shore";
    };

    theme = {
      enable = true;
      name = "catppuccin";
      flavor = "frappe";
      accent = "blue";
    };

    cursor = {
      enable = true;
      size = 32;
      name = "catppuccin";
      flavor = "frappe";
      accent = "dark";
    };

    bootscreen.enable = true;
  };

  # Set default shell
  shell.default = "fish";

  # Extra packages that don't necessarily need an entire dedicated module
  home-manager.users.${user}.home.packages = with pkgs; [
    bitwarden-desktop

    textpieces
    hieroglyphic
    impression
    switcheroo
    video-trimmer
    warp

    # Original electron teams package was abandoned
    teams-for-linux
  ];

}
