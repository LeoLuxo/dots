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
  config = modules.mkIf (cfg.enable && lists.elem "burnMyWindows" cfg.extensions) {
    programs.dconf.enable = true;

    home-manager.users.${constants.user} =
      { lib, ... }:
      {
        home.packages = with pkgs; [
          gnomeExtensions.burn-my-windows
        ];

        dconf.settings = {
          "org/gnome/shell" = {
            enabled-extensions = [ "burn-my-windows@schneegans.github.com" ];
          };

        };

        xdg.configFile."burn-my-windows/profiles/ddterm.conf".text = ''
          [burn-my-windows-profile]
          profile-app='com.github.amezin.ddterm'
          tv-glitch-enable-effect=true
          tv-glitch-animation-time=300
          fire-enable-effect=false
        '';

        xdg.configFile."burn-my-windows/profiles/main.conf".text = ''
          [burn-my-windows-profile]
          pixel-wipe-enable-effect=true
          pixel-wipe-animation-time=400
          pixel-wipe-pixel-size=15
          fire-enable-effect=false
        '';
      };
  };
}
