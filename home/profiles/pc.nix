{ homeProfiles, ... }:
{
  imports = [
    homeProfiles.base

    homeProfiles.common.fonts

    homeProfiles.scripts.clipboard
    homeProfiles.scripts.snip

    homeProfiles.scripts.dots
    homeProfiles.scripts.dotsTodo
    homeProfiles.scripts.dconfDiff
  ];
}
