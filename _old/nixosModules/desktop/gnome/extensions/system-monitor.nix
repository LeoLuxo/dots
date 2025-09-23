{
  pkgs,
  config,

  ...
}:

{
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    gnomeExtensions.system-monitor
  ];

  home-manager.users.${config.my.user.name} =
    { lib, ... }:
    {

      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "system-monitor@gnome-shell-extensions.gcampax.github.com" ];
        };

        "org/gnome/shell/extensions/system-monitor" = {
          show-cpu = true;
          show-memory = true;
          show-swap = false;
          show-upload = true;
          show-download = true;
        };
      };
    };
}
