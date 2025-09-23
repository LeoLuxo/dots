{
  pkgs,
  config,

  ...
}:

{
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    gnomeExtensions.burn-my-windows
  ];
  home-manager.users.${config.my.user.name} =
    { lib, ... }:
    {

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
}
