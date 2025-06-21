{
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib2) enabled;
in
{
  my = {
    suites.pc.laptop = {
      enable = true;
      username = "lili";
    };
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
