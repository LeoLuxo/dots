{
  pkgs,
  user,
  lib,
  ...
}:

with lib;

{
  environment.systemPackages = with pkgs; [
    # Next-gen Clipboard manager for Gnome Shell
    gnomeExtensions.pano
  ];

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;

    {
      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "pano@elhan.io" ];
        };

        # "org/gnome/shell/extensions/appindicator" = {
        #   icon-size = 0;
        #   tray-pos = "left";

        #   # custom-icons = [
        #   #   (mkTuple [
        #   #     "Vesktop"
        #   #     (traceValSeq "${moduleSet.discord}/discord-icon.png")
        #   #     ""
        #   #   ])
        #   # ];
        # };
      };
    };
}
