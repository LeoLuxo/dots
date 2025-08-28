{
  pkgs,
  config,
  ...
}:

{
  my.packages = with pkgs; [
    guake
  ];

  # Needs to start on boot
}
