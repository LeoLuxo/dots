{
  config,
  lib,

  ...
}:

let
  inherit (lib) modules;
  inherit (extraLib) mkEnable;
in
{
  options = {
    enable = mkEnable;
  };

  config = modules.mkIf cfg.enable {
    programs.steam = {
      # Install steam
      enable = true;

      # Open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = true;

      # Open ports in the firewall for Source Dedicated Server
      dedicatedServer.openFirewall = true;

      # Open ports in the firewall for Steam Local Network Game Transfers
      localNetworkGameTransfers.openFirewall = true;
    };

    # Add the gamescope compositor, which enables features such as resolution upscaling and stretched aspect ratios (such as 4:3)
    programs.steam.gamescopeSession.enable = true;
  };
}
