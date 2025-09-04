{ homeProfiles, ... }:
{
  imports = [
    homeProfiles.base

    homeProfiles.common.fonts
    homeProfiles.scripts.dots
    homeProfiles.scripts.dotsTodo
    homeProfiles.scripts.dconfDiff
  ];
}
