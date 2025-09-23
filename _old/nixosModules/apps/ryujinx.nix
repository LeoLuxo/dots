{
  pkgs,
  nixosModules,
  ...
}:

{
  imports = [ nixosModules.apps.joycons ];

  my.packages = [
    pkgs.ryubing
  ];
}
