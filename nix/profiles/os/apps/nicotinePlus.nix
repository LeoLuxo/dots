{
  pkgs,
  config,
  user,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    nicotine-plus # A client for the Soulseek peer-to-peer file sharing network.
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 2234 ];
  };

  # Autostart at boot
  home-manager.users.${user}.xdg.autostart.entries = [
    "${pkgs.nicotine-plus}/share/applications/org.nicotine_plus.Nicotine.desktop"
  ];

}
