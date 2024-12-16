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

  home-manager.users.${user} =
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
          elements-order = [
            "ICON"
            "LABEL"
            "CONTROLS"
          ];
          extension-index = mkUint32 2;
          extension-position = "Right";
          fixed-label-width = false;
          label-width = mkUint32 200;
          mouse-action-double = "RAISE_PLAYER";
          mouse-action-scroll-down = "NONE";
          mouse-action-scroll-up = "NONE";
          show-control-icons-seek-backward = false;
          show-control-icons-seek-forward = false;
          show-label = true;
        };
      };
    };
}
