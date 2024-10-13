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

        # Enable automatic location services (in privacy tab)
        "org/gnome/system/location" = {
          enabled = true;
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
          ];
          my-loc-prov = "ipinfoio";
          position-in-panel = "center";
          position-index = 1;
          show-comment-in-panel = false;
          show-sunsetrise-in-panel = false;
          show-text-in-panel = true;

        };
      };
    };
}
