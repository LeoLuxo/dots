{

  config,
  pkgs,
  user,
  ...
}:

{
  environment.systemPackages = [
    pkgs.steam-rom-manager
  ];
}
