{
  config,
  pkgs,
  constants,
  ...
}:

let
  dm = config.services.xserver.displayManager;
  isWayland = dm.gdm.wayland || dm.sddm.wayland;
in

if isWayland then
  # Running under wayland, use wl-clipboard
  {
    home-manager.users.${constants.user} = {
      home.packages = [
        pkgs.wl-clipboard
      ];

      home.shellAliases = {
        "copy" = "wl-copy";
        "paste" = "wl-paste";
      };
    };
  }
else
  # Running under X11, use xclip maybe?
  (builtins.abort "Clipboard under X11 isn't implemented (yet)!")
