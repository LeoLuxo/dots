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
  ];

  wallpaper.image = directories.wallpapers.dynamic."Tree and shore";

  rice.peppy.cursor.size = 32;

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
