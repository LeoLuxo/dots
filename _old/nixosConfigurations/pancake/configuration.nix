{
  pkgs,
  nixosModules,
  lib2,
  inputs,
  user,
  ...
}:

let
  inherit (lib2) enabled;
in
{
  imports = [
    # Include hardware stuff and kernel patches for surface pro 7
    # inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel

    nixosModules.rices.peppy

    nixosModules.shell.bash
    nixosModules.shell.fish
    # nixosModules.shell.nushell

    nixosModules.scripts.snip
    nixosModules.scripts.terminal-utils
    nixosModules.scripts.clipboard

    # nixosModules.apps.deepl
    nixosModules.apps.youtube-music
    nixosModules.apps.gnome-dialect
    nixosModules.apps.obsidian
    nixosModules.apps.firefox
    nixosModules.apps.discord
    nixosModules.apps.vscode
    nixosModules.apps.git
    nixosModules.apps.steam
    nixosModules.apps.bitwarden
    nixosModules.apps.upscaler
    nixosModules.apps.zoxide
  ];

  my = {
    user.name = "lili";

    symlinks = {
      enable = true;
    };

    scripts.nx = {
      enable = true;
    };

    desktop.defaultAppsShortcuts = {
      enable = true;
    };

    # system.pinKernel = {enable = true;};

    paths = {
      nixosTodo = "/stuff/obsidian/Notes/NixOS Todo.md";
      nixosRepo = "/etc/nixos/dots";
    };
  };

  # hardware.microsoft-surface.kernelVersion = "longterm";

  # Extra packages that don't necessarily need an entire dedicated module
  environment.systemPackages = with pkgs; [
    textpieces # A developer’s scratchpad that lets you quickly experiment with and transform text.
    hieroglyphic # An application that helps you locate and select LaTeX symbols by drawing or sketching them.
    impression # A utility for creating bootable USB drives from disk images.
    switcheroo # A tool for converting and manipulating images (for example, resizing or reformatting them).
    video-trimmer # A simple app designed to quickly trim and edit video clips.
    warp # A fast, secure file transfer utility for moving files efficiently between systems.
    gnome-2048 # A GNOME-native implementation of the popular 2048 puzzle game.
    teams-for-linux # Microsoft Teams client recreated, the original electron teams package was abandoned
    eyedropper # A simple color picker tool that allows you to select a color from anywhere on the screen.

    styluslabs-write
  ];

  # wallpaper.image = inputs.wallpapers.dynamic."treeAndShore";

  rice.peppy = {
    enable = true;
    cursor.size = 32;
  };

  # Set default shell
  shell.default = "fish";

  desktop.gnome = {
    enable = true;

    power = {
      buttonAction = "suspend";
      confirmShutdown = true;

      screenIdle = {
        enable = true;
        delay = 600;
      };

      suspendIdle = {
        enable = true;
        delay = 900;
      };
    };
  };

  # SD Card
  # fileSystems."/stuff" = {
  #   device = "/dev/disk/by-label/stuff";
  #   fsType = "btrfs";
  # };

  # Enable and configure the X11 windowing system.
  services.xserver = {
    enable = true;

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "altgr-intl";
    };

    # Touchscreen support
    # modules = [ pkgs.xf86_input_wacom ];
    # wacom.enable = true;
  };

  # Also for touchscreen support (or maybe touchpad? unsure)
  # services.libinput.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
}
