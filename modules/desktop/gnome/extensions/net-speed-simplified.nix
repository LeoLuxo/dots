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

  home-manager.users.${constants.user} =
    { lib, ... }:
    {
      home.packages = with pkgs; [
        gnomeExtensions.net-speed-simplified
      ];

      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "netspeedsimplified@prateekmedia.extension" ];
        };

        # "org/gnome/shell/extensions/netspeedsimplified" = {
        # };
      };
    };
}
