{
  pkgs,
  constants,
  ...
}:
let
  inherit (constants) user;
in
{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      nicotine-plus # A client for the Soulseek peer-to-peer file sharing network.
    ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 2234 ];
  };
}
