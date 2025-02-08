{
  pkgs,
  constants,
  config,
  lib,
  ...
}:

let
  inherit (lib) modules lists;
in

{
  config = modules.mkIf (cfg.enable && lists.elem "mediaControls" cfg.extensions) {
    programs.dconf.enable = true;

    home-manager.users.${constants.user} =
      { lib, ... }:
      let
        inherit (lib.hm.gvariant) mkUint32;
      in
      {
        home.packages = with pkgs; [
          gnomeExtensions.media-controls
        ];

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
  };
}
