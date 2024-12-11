{ directories, ... }:

{
  imports = [
    directories.modules.fonts

    ./wallpaper
    ./theme
    ./cursor

    ./bootscreen.nix
  ];
}
