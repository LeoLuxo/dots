{ inputs, homeProfiles, ... }:
{
  imports = [
    homeProfiles.pc
  ];

  wallpaper.image = inputs.wallpapers.dynamic."treeAndShore";
}
