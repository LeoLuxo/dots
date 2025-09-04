{ inputs, homeProfiles, ... }:
{
  imports = [
    homeProfiles.pc

    homeProfiles.scripts.bootWindows
    homeProfiles.scripts.autoMusic
  ];

  wallpaper.image = inputs.wallpapers.static."lofiJapan";
}
