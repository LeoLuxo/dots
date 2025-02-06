{
  pkgs,
  nixosModules,
  constants,
  inputs,
  ...
}:

let
  inherit (constants) user;
in

{
  # Include global modules
  imports = with nixosModules; [
    rices.peppy

    shell.bash
    shell.fish
    # shell.nushell

    scripts.nix-utils
    scripts.snip
    scripts.terminal-utils
    scripts.clipboard

    # apps.deepl
    apps.youtube-music
    apps.gnome-dialect
    apps.obsidian
    apps.firefox
    apps.discord
    apps.vscode
    apps.git
    apps.steam
    apps.bitwarden
  ];

  # Extra packages that don't necessarily need an entire dedicated module
  home-manager.users.${user}.home.packages = with pkgs; [
    textpieces # A developer’s scratchpad that lets you quickly experiment with and transform text.
    hieroglyphic # An application that helps you locate and select LaTeX symbols by drawing or sketching them.
    impression # A utility for creating bootable USB drives from disk images.
    switcheroo # A tool for converting and manipulating images (for example, resizing or reformatting them).
    video-trimmer # A simple app designed to quickly trim and edit video clips.
    warp # A fast, secure file transfer utility for moving files efficiently between systems.
    upscaler # An application that enhances image resolution by upscaling photos using advanced processing (designed in the GNOME spirit).
    gnome-2048 # A GNOME-native implementation of the popular 2048 puzzle game.
    teams-for-linux # Microsoft Teams client recreated, the original electron teams package was abandoned
  ];

  wallpaper.image = inputs.wallpapers.dynamic."Tree and shore";

  rice.peppy = {
    enable = true;
    cursor.size = 32;
  };

  # Set default shell
  shell.default = "fish";

  # Auto-update wallpaper repo
  nx.rebuild.preRebuildActions = ''
    echo Updating wallpaper flake
    nix flake lock --update-input wallpapers --allow-dirty
  '';
}
