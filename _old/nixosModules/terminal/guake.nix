{
  pkgs,
  config,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    guake
  ];

  # Needs to start on boot
}
