{
  pkgs,
  nixosModules,
  user,
  ...
}:

{
  imports = [ nixosModules.apps.joycons ];

  environment.systemPackages = [
    pkgs.ryubing
  ];
}
