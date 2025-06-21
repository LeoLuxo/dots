{
  pkgs,
  config,
  constants,
  ...
}:

{
  programs.dconf.enable = true;

  my.packages = with pkgs; [
    gnomeExtensions.media-controls
  ];

  home-manager.users.${config.my.system.user.name} =
    { lib, ... }:
    let
      inherit (lib.hm.gvariant) mkUint32;
    in
    {

      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "mediacontrols@cliffniff.github.com" ];
        };

        "org/gnome/shell/extensions/mediacontrols" = {
          blacklisted-players = [ "firefox.desktop" ];
          colored-player-icon = true;
          elements-order = [
            "ICON"
            "LABEL"
            "CONTROLS"
          ];
          extension-index = mkUint32 1;
          extension-position = "Left";
          fixed-label-width = true;
          label-width = mkUint32 300;
          labels-order = [
            "ARTIST"
            "-"
            "TITLE"
            "          "
          ];
          mouse-action-double = "RAISE_PLAYER";
          mouse-action-scroll-down = "NONE";
          mouse-action-scroll-up = "NONE";
          show-control-icons-next = false;
          show-control-icons-play = false;
          show-control-icons-previous = false;
          show-control-icons-seek-backward = false;
          show-control-icons-seek-forward = false;
          show-label = true;
          show-player-icon = true;
        };
      };
    };
}
