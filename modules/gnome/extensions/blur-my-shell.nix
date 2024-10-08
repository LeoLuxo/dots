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

    # Adds a blur look to different parts of the GNOME Shell, including the top panel, dash and overview.
    gnomeExtensions.blur-my-shell
  ];

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;

    {
      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "blur-my-shell@aunetx" ];
        };

        "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
          blur = true;
          brightness = 0.6;
          sigma = 30;
        };

        "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
          blur = false;
          brightness = 0.6;
          pipeline = "pipeline_default_rounded";
          sigma = 30;
          static-blur = true;
          style-dash-to-dock = 0;
        };

        "org/gnome/shell/extensions/blur-my-shell/hidetopbar" = {
          compatibility = false;
        };

        "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
          pipeline = "pipeline_default";
        };

        "org/gnome/shell/extensions/blur-my-shell/overview" = {
          blur = true;
          pipeline = "pipeline_default";
          style-components = 1;
        };

        "org/gnome/shell/extensions/blur-my-shell/panel" = {
          blur = true;
          brightness = 0.6;
          force-light-text = false;
          override-background-dynamically = false;
          pipeline = "pipeline_default";
          sigma = 30;
          static-blur = true;
          style-panel = 3;
          unblur-in-overview = true;
        };

        "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
          blur = true;
          pipeline = "pipeline_default";
        };

        "org/gnome/shell/extensions/blur-my-shell/window-list" = {
          brightness = 1.0;
          sigma = 30;
        };
      };
    };
}
