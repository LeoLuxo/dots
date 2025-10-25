{ ... }:
{
  # Playstation controller compatibility
  boot.kernelModules = [
    "hid_sony"
    "hid_playstation"
  ];

  # Joycon compatibility (couldn't get it to work)
  # environment.systemPackages = [
  #   pkgs.joycond-cemuhook
  # ];
  # services.joycond.enable = true;
}
