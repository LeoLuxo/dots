{
  pkgs,
  ...
}:

{
  ext.packages = with pkgs; [
    guake
  ];

  # Needs to start on boot
}
