{
  pkgs,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  programs.dconf.enable = true;

  ext.packages = with pkgs; [
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
