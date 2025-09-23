{
  pkgs,
  config,
  ...
}:

{
  my.packages = [
    pkgs.joycond-cemuhook
  ];

  services.joycond.enable = true;
}
