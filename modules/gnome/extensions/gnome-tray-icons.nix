{
  pkgs,
  user,
  lib,
  globalModules,
  ...
}:

with lib;
with lib.hm.gvariants;

{
  environment.systemPackages = with pkgs; [
    # Adds AppIndicator, KStatusNotifierItem and legacy Tray icons support to the Shell
    # (Because gnome by default doesn't support tray icons)
    gnomeExtensions.appindicator
  ];

  home-manager.users.${user} = {
    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [ "appindicatorsupport@rgcjonas.gmail.com" ];
      };

      "org/gnome/shell/extensions/appindicator" = {
        custom-icons = [
          (mkTuple [
            "Vesktop"
            (traceValSeq "${globalModules.discord}/discord-icon.png")
            ""
          ])
        ];
        icon-size = 0;
        tray-pos = "left";
      };
    };
  };
}
