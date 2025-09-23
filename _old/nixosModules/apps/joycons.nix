{
  pkgs,
  config,
  ...
}:

{
  environment.systemPackages = [
    pkgs.joycond-cemuhook
  ];

  services.joycond.enable = true;
}
