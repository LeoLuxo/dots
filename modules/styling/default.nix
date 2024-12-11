{ directories, ... }:

{
  imports = [
    directories.modules.fonts

    ./wallpaper
    ./theme

    ./bootscreen.nix
  ];
}
