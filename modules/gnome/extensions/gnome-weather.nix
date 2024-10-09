{
  pkgs,
  user,
  lib,
  ...
}:

with lib;

{
  environment.systemPackages = with pkgs; [
    dconf
    gnomeExtensions.openweather-refined
  ];

  home-manager.users.${user} =
    { lib, ... }:
    with lib.hm.gvariant;

    {
      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "openweather-extension@penguin-teal.github.io" ];
        };

        "org/gnome/shell/extensions/openweatherrefined" = {
          actual-city = 1;
          has-run = true;
          locs = [
            (mkTuple [
              (mkUint32 1)
              ""
              (mkUint32 1)
              ""
            ])
            (mkTuple [
              0
              "Aarhus, Aarhus Kommune, Region Midtjylland, 8000, Danmark"
              0
              "56.1496278,10.2134046"
            ])
          ];
          my-loc-prov = "ipinfoio";
          position-in-panel = "center";
          show-comment-in-panel = true;
          show-sunsetrise-in-panel = true;
        };
      };
    };
}
