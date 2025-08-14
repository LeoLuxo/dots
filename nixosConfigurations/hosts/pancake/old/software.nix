{
  pkgs,
  config,
  constants,
  inputs,
  ...
}:

{
  # Include global modules
  imports = [
    ../../modules/rices/peppy

    ../../modules/shell/bash
    ../../modules/shell/fish
    # ../../modules/shell/nushell

    ../../modules/scripts/snip
    ../../modules/scripts/terminal-utils
    ../../modules/scripts/clipboard

    # ../../modules/apps/deepl
    ../../modules/apps/youtube-music
    ../../modules/apps/gnome-dialect
    ../../modules/apps/obsidian
    ../../modules/apps/firefox
    ../../modules/apps/discord
    ../../modules/apps/vscode
    ../../modules/apps/git
    ../../modules/apps/steam
    ../../modules/apps/bitwarden
    ../../modules/apps/upscaler
  ];

  # Extra packages that don't necessarily need an entire dedicated module
  my.packages = with pkgs; [
    textpieces # A developer’s scratchpad that lets you quickly experiment with and transform text.
    hieroglyphic # An application that helps you locate and select LaTeX symbols by drawing or sketching them.
    impression # A utility for creating bootable USB drives from disk images.
    switcheroo # A tool for converting and manipulating images (for example, resizing or reformatting them).
    video-trimmer # A simple app designed to quickly trim and edit video clips.
    warp # A fast, secure file transfer utility for moving files efficiently between systems.
    gnome-2048 # A GNOME-native implementation of the popular 2048 puzzle game.
    teams-for-linux # Microsoft Teams client recreated, the original electron teams package was abandoned
    eyedropper # A simple color picker tool that allows you to select a color from anywhere on the screen.
  ];

  wallpaper.image = inputs.wallpapers.dynamic."treeAndShore";

  rice.peppy = {
    enable = true;
    cursor.size = 32;
  };

  # Set default shell
  shell.default = "fish";

  # Auto-update wallpaper repo
  my.scripts.nx.rebuild.preRebuildActions = ''
    echo "Updating wallpaper flake"
    nix flake update wallpapers --allow-dirty
    git add flake.lock
  '';
}
