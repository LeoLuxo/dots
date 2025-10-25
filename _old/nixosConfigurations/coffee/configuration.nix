{
  inputs,
  nixosModules,
  pkgs,
  lib2,
  user,
  ...
}:

let
  inherit (lib2) enabled;
in
{

  imports = [
    nixosModules.rices.peppy

    nixosModules.shell.bash
    nixosModules.shell.fish
    # nixosModules.shell.nushell

    nixosModules.scripts.snip
    nixosModules.scripts.terminal-utils
    nixosModules.scripts.clipboard
    nixosModules.scripts.boot-windows
    nixosModules.scripts.automusic

    nixosModules.apps.youtube-music
    nixosModules.apps.obsidian
    nixosModules.apps.firefox
    nixosModules.apps.discord
    nixosModules.apps.vscode
    nixosModules.apps.git
    nixosModules.apps.steam
    nixosModules.apps.qmk
    nixosModules.apps.bitwarden
    nixosModules.apps.llm
    nixosModules.apps.upscaler
    nixosModules.apps.zoxide

    nixosModules.apps.distrobox
    nixosModules.apps.nicotine-plus
    nixosModules.apps.sldl

    # nixosModules.apps.sudachi
    nixosModules.apps.steamRomManager
    nixosModules.apps.yuzu
    nixosModules.apps.ryujinx

  ];

  # Extra packages that don't necessarily need an entire dedicated module
  environment.systemPackages = with pkgs; [
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
    cemu
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

  # wallpaper.image = inputs.wallpapers.static."lofiJapan";

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

    display.textScalingPercent = 150;
  };

  # # 1TB SSD
  # fileSystems."/stuff" = {
  #   device = "/dev/disk/by-label/stuff";
  #   fsType = "ext4";
  # };

  # # 4TB HDD
  # fileSystems."/backup" = {
  #   device = "/dev/disk/by-label/backup";
  #   fsType = "ntfs";
  # };

  my = {
    suites.pc.desktop =
      {
        enable = true;
      }
      // {
        username = "lili";
      };

    symlinks = {
      enable = true;

      xdgConfig."Ryujinx" = "/stuff/games/emu/switch/ryujinx";
      xdgConfig."steam-rom-manager/userData" = "/stuff/games/emu/steamRomManager/userData";
      xdgData."sudachi" = "/stuff/games/emu/switch/yuzu";
      xdgData."yuzu" = "/stuff/games/emu/switch/yuzu";
      xdgData."Cemu" = "/stuff/games/emu/wiiu/Cemu";
      xdgData."ukmm" = "/stuff/games/emu/wiiu/ukmm";
    };

    # system.pinKernel = {enable = true;};

    desktop.defaultAppsShortcuts = {
      enable = true;
    };

    paths = {
      nixosTodo = "/stuff/obsidian/Notes/NixOS Todo.md";
      nixosRepo = "/etc/nixos/dots";
    };

    hardware.controller.playstation = {
      enable = true;
    };
  };

}
