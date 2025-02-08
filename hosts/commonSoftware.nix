{
  pkgs,
  constants,
  ...
}:

{
  # Extra packages that don't necessarily need an entire dedicated module
  home-manager.users.${constants.user}.home.packages = with pkgs; [
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
  ];

  scripts = {
    snip.enable = true;
    terminal-utils.enable = true;
    clipboard.enable = true;

    nx = {
      enable = true;

      # Auto-update wallpaper repo
      rebuild.preRebuildActions = ''
        echo Updating wallpaper flake
        nix flake update wallpapers --allow-dirty
      '';
    };
  };

  apps = {
    youtubeMusic.enable = true;
    obsidian.enable = true;
    firefox.enable = true;
    discord.enable = true;
    vscode.enable = true;
    git.enable = true;
    steam.enable = true;
    bitwarden.enable = true;
    upscaler.enable = true;
  };

  wallpaper.enable = true;

  shell = {
    # Set default shell
    defaultShell = "fish";

    bash.enable = true;
    fish.enable = true;
    # nushell.enable = true;
  };

  rice.peppy = {
    enable = true;

    blur = {
      enable = true;
      # Enable blur for all applications
      # app-blur.enable = true;

      # Set hacks to best looking
      hacksLevel = "no artifact";
    };
  };

}
