{ pkgs, lib, ... }:

with builtins;
with lib.gvariant;

{
  home.packages = with pkgs; [
    # Adds AppIndicator, KStatusNotifierItem and legacy Tray icons support to the Shell
    # (Because gnome by default doesn't support tray icons)
    gnomeExtensions.appindicator
  ];

  dconf.settings = {
    # Enable extensions
    "org/gnome/shell" = {
      enabled-extensions = [ "appindicatorsupport@rgcjonas.gmail.com" ];
    };

    # Tray icon settings
    "org/gnome/shell/extensions/appindicator" = {
      custom-icons = [
        (mkTuple [
          "Vesktop"
          "${./discord-white-icon.png}"
          ""
        ])
      ];
      icon-size = 0;
      tray-pos = "left";
    };
  };
}
