{
  inputs,
  nixosModules,
  pkgs,
  lib2,
  user,
  ...
}:

let
  inherit (lib2) enabled;
in
{

  imports = [
    nixosModules.rices.peppy

    nixosModules.scripts.terminal-utils

    nixosModules.apps.youtube-music
    nixosModules.apps.vscode
    nixosModules.apps.zoxide
  ];

  # wallpaper.image = inputs.wallpapers.static."lofiJapan";

  rice.peppy = {
    enable = true;

    cursor.size = 16;

    blur = {
      enable = true;
      # Enable blur for all applications
      # app-blur.enable = true;

      # Set hacks to best looking
      hacks-level = "no artifact";
    };
  };

  programs.gamescope.enable = true;

  desktop.gnome = {
    enable = true;

    power = {
      buttonAction = "power off";
      confirmShutdown = false;

      screenIdle = {
        enable = true;
        delay = 600;
      };

      suspendIdle.enable = false;
    };

    display.textScalingPercent = 150;
  };

}
