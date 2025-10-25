{ pkgs, user, ... }:
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

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # Steam
  programs.steam = {
    enable = true;

    # Open ports in the firewall for Steam Remote Play
    remotePlay.openFirewall = true;

    # Open ports in the firewall for Source Dedicated Server
    dedicatedServer.openFirewall = true;

    # Open ports in the firewall for Steam Local Network Game Transfers
    localNetworkGameTransfers.openFirewall = true;

    # Add the gamescope compositor, which enables features such as resolution upscaling and stretched aspect ratios (such as 4:3)
    gamescopeSession.enable = true;
  };

  programs.gamescope.enable = true;

  home-manager.users.${user}.home.packages = [
    pkgs.r2modman # A mod manager for Risk of Rain 2 and other Unity games.
    pkgs.joystickwake # Prevents screen sleep when playing games with a gamepad
  ];
}
