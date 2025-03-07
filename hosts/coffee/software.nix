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
    scripts.boot-windows

    apps.restic

    apps.youtube-music
    apps.obsidian
    apps.firefox
    apps.discord
    apps.vscode
    apps.git
    apps.steam
    apps.qmk
    apps.bitwarden
    apps.llm
    apps.upscaler

    apps.distrobox
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
    eyedropper # A simple color picker tool that allows you to select a color from anywhere on the screen.

    guitarix # A virtual guitar amplifier for use with Linux.
    r2modman # A mod manager for Risk of Rain 2 and other Unity games.

    (pkgs.symlinkJoin {
      name = "prismlauncher";
      paths = [ pkgs.prismlauncher ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/prismlauncher \
          --set QT_SCALE_FACTOR 1.5
      '';
    })
  ];

  wallpaper.image = inputs.wallpapers.static."lofiJapan";

  # Set default shell
  shell.default = "fish";

  rice.peppy = {
    enable = true;

    cursor.size = 16;

    blur = {
      enable = true;
      # Enable blur for all applications
      # app-blur.enable = true;

      # Set hacks to best looking
      hacks-level = "no artifact";
    };
  };

  # Auto-update wallpaper repo
  nx.rebuild.preRebuildActions = ''
    echo Updating wallpaper flake
    nix flake update wallpapers --allow-dirty
    git add flake.lock
  '';
}
