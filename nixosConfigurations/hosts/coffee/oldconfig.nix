{

  inputs,
  pkgs,
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
    ../../modules/scripts/boot-windows
    ../../modules/scripts/automusic

    ../../modules/apps/youtube-music
    ../../modules/apps/obsidian
    ../../modules/apps/firefox
    ../../modules/apps/discord
    ../../modules/apps/vscode
    ../../modules/apps/git
    ../../modules/apps/steam
    ../../modules/apps/qmk
    ../../modules/apps/bitwarden
    ../../modules/apps/llm
    ../../modules/apps/upscaler

    ../../modules/apps/distrobox
    ../../modules/apps/nicotine-plus
    ../../modules/apps/sldl

    # ../../modules/apps/sudachi
    ../../modules/apps/steamRomManager
    ../../modules/apps/yuzu
    ../../modules/apps/ryujinx
  ];

  # Extra packages that don't necessarily need an entire dedicated module
  my.packages = with pkgs; [
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
    celluloid # A simple video player

    guitarix # A virtual guitar amplifier for use with Linux.
    r2modman # A mod manager for Risk of Rain 2 and other Unity games.

    joystickwake # Prevents screen sleep when playing games with a gamepad

    picard
    # lutris
    snes9x
    snes9x-gtk
    melonDS
    # higan

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

  programs.gamescope.enable = true;

  desktop.gnome = {
    enable = true;

    power = {
      buttonAction = "power off";
      confirmShutdown = false;

      screenIdle = {
        enable = true;
        delay = 600;
      };

      suspendIdle.enable = false;
    };
  };

  # Add strobery as a local host
  networking.hosts = {
    "192.168.0.37" = [ "strobery" ];
  };

  # Enable and configure the X11 windowing system.
  services.xserver = {
    enable = true;

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "altgr-intl";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
