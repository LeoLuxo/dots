{
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib2) enabled;
in
{
  ext = {
    suites.laptop = enabled;
    touchscreen = enabled;

    keyboard = {
      layout = "us";
      variant = "altgr-intl";
    };
  };

  # SD Card
  fileSystems."/stuff" = {
    device = "/dev/disk/by-label/stuff";
    fsType = "btrfs";
  };
}
