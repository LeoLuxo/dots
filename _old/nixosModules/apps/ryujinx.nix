{
  pkgs,
  nixosModules,
  ...
}:

{
  imports = [ nixosModules.apps.joycons ];

  environment.systemPackages = [
    pkgs.ryubing
  ];
}
