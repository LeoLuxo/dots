{
  pkgs,
  user,
  lib,
  ...
}:

with lib;

{
  programs.dconf.enable = true;

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;
    {
      home.packages = with pkgs; [
        gnomeExtensions.burn-my-windows
      ];

      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "burn-my-windows@schneegans.github.com" ];
        };

      };

      xdg.configFile."burn-my-windows/profiles/main.conf".text = ''
        [burn-my-windows-profile]
        profile-app='com.github.amezin.ddterm'
        fire-enable-effect=false
        tv-glitch-enable-effect=true
        tv-glitch-animation-time=300
      '';

      xdg.configFile."burn-my-windows/profiles/ddterm.conf".text = ''
        [burn-my-windows-profile]
        fire-enable-effect=false
        pixel-wipe-enable-effect=true
        pixel-wipe-animation-time=300
      '';
    };
}
