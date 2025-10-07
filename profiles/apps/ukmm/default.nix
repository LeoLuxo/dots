{ pkgs, ... }:
{
  hm.home.packages = [ (pkgs.callPackage ./package.nix { }) ];
}
