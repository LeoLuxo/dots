{

  config,
  user,
  pkgs,
  ...
}:

{
  environment.systemPackages = [
    pkgs.steam-rom-manager
  ];
}
