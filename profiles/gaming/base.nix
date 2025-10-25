{ ... }:
{
  # Playstation controller compatibility
  boot.kernelModules = [
    "hid_sony"
    "hid_playstation"
  ];
}
