{ profiles, ... }:
{
  imports = [
    profiles.scripts.dots
    profiles.scripts.dconfDiff
    profiles.scripts.dotsTodo
  ];
}
