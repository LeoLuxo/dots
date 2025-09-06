{ inputs, homeProfiles, ... }:
{
  imports = [
    homeProfiles.pc
    homeProfiles.gaming
  ];

  wallpaper.image = inputs.wallpapers.dynamic."treeAndShore";

  gnome = {
    power = {
      buttonAction = "suspend";
      confirmShutdown = true;

      screenIdle = {
        enable = true;
        delay = 600;
      };

      suspendIdlePluggedIn = {
        enable = true;
        delay = 900;
      };

      suspendIdleOnBattery = {
        enable = true;
        delay = 600;
      };

      cursorSize = 32;
    };
  };
}
