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
  ];

  # wallpaper.image = inputs.wallpapers.static."lofiJapan";

  programs.gamescope.enable = true;

}
