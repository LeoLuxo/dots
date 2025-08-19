{
  pkgs,
  nixosModulesOld,
  ...
}:

{
  imports = [ nixosModulesOld.apps.joycons ];

  my.packages = [
    pkgs.ryubing
  ];
}
