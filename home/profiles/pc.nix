{ homeProfiles, ... }:
{
  imports = [
    homeProfiles.base

    homeProfiles.common.fonts
  ];
}
