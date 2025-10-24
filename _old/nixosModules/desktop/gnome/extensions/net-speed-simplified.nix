{
  pkgs,
  config,

  user,
  ...
}:

{
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    gnomeExtensions.net-speed-simplified
  ];

  home-manager.users.${user} =
    { lib, ... }:
    {

      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "netspeedsimplified@prateekmedia.extension" ];
        };

        # "org/gnome/shell/extensions/netspeedsimplified" = {
        # };
      };
    };
}
