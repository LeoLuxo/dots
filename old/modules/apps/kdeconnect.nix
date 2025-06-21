{
  constants,
  config,
  ...
}:

{
  home-manager.users.${config.ext.system.user.name} = {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
  };
}
