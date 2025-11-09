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

    nixosModules.scripts.snip
    nixosModules.scripts.terminal-utils
    nixosModules.scripts.boot-windows

    nixosModules.apps.youtube-music
    nixosModules.apps.vscode
    nixosModules.apps.qmk
    nixosModules.apps.upscaler
    nixosModules.apps.zoxide

  ];

  # Extra packages that don't necessarily need an entire dedicated module
  environment.systemPackages = with pkgs; [

    guitarix # A virtual guitar amplifier for use with Linux
    picard
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
