{
  constants,
  config,
  pkgs,
  nixosModulesOld,
  ...
}:

{
  imports = [ nixosModulesOld.apps.joycons ];

  my.packages = [
    pkgs.ryubing
  ];

  my.symlinks.xdgConfig."Ryujinx" = "/stuff/games/roms/switch/data/ryujinx";
}
