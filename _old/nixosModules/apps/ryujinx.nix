{
  pkgs,
  nixosModules,
  user,
  ...
}:

{

  environment.systemPackages = [
    pkgs.ryubing
  ];
}
