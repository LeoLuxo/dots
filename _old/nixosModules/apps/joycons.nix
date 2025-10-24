{
  pkgs,
  config,
  user,
  ...
}:

{
  environment.systemPackages = [
    pkgs.joycond-cemuhook
  ];

  services.joycond.enable = true;
}
