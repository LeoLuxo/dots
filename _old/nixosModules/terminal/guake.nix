{
  pkgs,
  config,
  user,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    guake
  ];

  # Needs to start on boot
}
