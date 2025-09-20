{
  pkgs,
  inputs,
  homeProfiles,
  ...
}:
{
  imports = [
    ./syncthing.nix
    ./backups.nix

    homeProfiles.pc
    homeProfiles.personal
    homeProfiles.music
    
    homeProfiles.gaming.base
    homeProfiles.gaming.emulation
    homeProfiles.gaming.minecraft
    
    homeProfiles.scripts.bootWindows
  ];

  home.packages = [
    pkgs.guitarix # A virtual guitar amplifier for use with Linux.
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
