{ pkgs, ... }:
{
  # Playstation controller compatibility
  boot.kernelModules = [
    "hid_sony"
    "hid_playstation"
  ];

  # Joycon compatibility
  environment.systemPackages = [
    pkgs.joycond-cemuhook
  ];

  services.joycond.enable = true;
}
