{
  pkgs,
  config,

  ...
}:

{
  programs.dconf.enable = true;

  # Enable the automatic location provider on the system
  # (doesn't seem to be working tho :/)
  services.geoclue2.enable = true;
  location.provider = "geoclue2";

  environment.systemPackages = with pkgs; [
    gnomeExtensions.openweather-refined
  ];

  home-manager.users.${config.my.user.name} =
    { lib, ... }:
    let
      inherit (lib.hm.gvariant) mkTuple mkUint32;
    in
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
          my-loc-prov = "geoclue";
          position-in-panel = "center";
          position-index = 1;
          show-comment-in-panel = false;
          show-sunsetrise-in-panel = false;
          show-text-in-panel = true;
        };
      };
    };
}
