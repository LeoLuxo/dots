{
  pkgs,
  config,
  constants,
  ...
}:

{
  programs.dconf.enable = true;

  my.packages = with pkgs; [
    gnomeExtensions.net-speed-simplified
  ];

  home-manager.users.${config.my.user.name} =
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
