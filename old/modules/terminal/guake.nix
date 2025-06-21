{
  pkgs,
  config,
  ...
}:

{
  ext.packages = with pkgs; [
    guake
  ];

  # Needs to start on boot
}
