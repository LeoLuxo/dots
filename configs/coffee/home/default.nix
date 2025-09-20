{ inputs, homeProfiles, ... }:
{
  imports = [
    ./syncthing.nix
    ./backups.nix

    homeProfiles.pc
    homeProfiles.personal
    homeProfiles.gaming
    homeProfiles.emulation

    homeProfiles.scripts.bootWindows
    homeProfiles.scripts.autoMusic
  ];

  wallpaper.image = inputs.wallpapers.static."lofiJapan";

  gnome = {
    power = {
      buttonAction = "power off";
      confirmShutdown = false;

      screenIdle = {
        enable = true;
        delay = 600;
      };

      suspendIdlePluggedIn.enable = false;
    };

    textScalingPercent = 150;

    cursorSize = 16;

    blur = {
      enable = true;
      # Enable blur for all applications
      # appBlur.enable = true;

      # Set hacks to best looking
      hacksLevel = "no artifact";
    };
  };
}
