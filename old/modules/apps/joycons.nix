{
  pkgs,
  config,
  ...
}:

{
  ext.packages = [
    pkgs.joycond-cemuhook
  ];

  services.joycond.enable = true;
}
