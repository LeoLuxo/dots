{
  pkgs,
  config,
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

    apps.distrobox
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
    ];
  };

  wallpaper.image = inputs.wallpapers.static."RainyDay";

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

  # Setup my auto backups
  restic = {
    enable = true;
    repo = "/stuff/Restic/repo";
    passwordFile = config.age.secrets."restic/${constants.hostName}-pwd".path;

    backups = {
      "obsidian" = {
        path = "/stuff/Obsidian";
        timer = "*:0/2"; # https://unix.stackexchange.com/questions/126786/systemd-timer-every-15-minutes
        label = "Obsidian";
        displayPath = "Obsidian";
        tags = [ "obsidian" ];
      };
    };
  };

  # Auto-update wallpaper repo
  nx.rebuild.preRebuildActions = ''
    echo Updating wallpaper flake
    nix flake lock --update-input wallpapers --allow-dirty
  '';
}
