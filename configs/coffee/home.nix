{ inputs, homeProfiles, ... }:
{
  imports = [
    homeProfiles.pc
  ];

  wallpaper.image = inputs.wallpapers.static."lofiJapan";
}
