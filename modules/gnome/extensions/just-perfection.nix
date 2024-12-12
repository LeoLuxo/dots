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
  environment.systemPackages = with pkgs; [
    gnomeExtensions.just-perfection
  ];

  home-manager.users.${user} =
    { lib, ... }:
    # with lib.hm.gvariant;

    {
      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "just-perfection-desktop@just-perfection" ];
        };

        "org/gnome/shell/extensions/just-perfection" = {
          accessibility-menu = false;
          activities-button = true;
          alt-tab-window-preview-size = 0;
          animation = 5;
          background-menu = true;
          clock-menu = true;
          clock-menu-position = 0;
          clock-menu-position-offset = 0;
          controls-manager-spacing-size = 0;
          dash = false;
          dash-icon-size = 0;
          double-super-to-appgrid = true;
          keyboard-layout = false;
          max-displayed-search-results = 0;
          notification-banner-position = 1;
          osd = true;
          osd-position = 5;
          panel = true;
          panel-in-overview = true;
          panel-notification-icon = true;
          panel-size = 0;
          power-icon = true;
          quick-settings = true;
          quick-settings-dark-mode = false;
          ripple-box = true;
          search = true;
          show-apps-button = false;
          startup-status = 0;
          switcher-popup-delay = false;
          theme = false;
          top-panel-position = 0;
          weather = false;
          window-demands-attention-focus = true;
          window-maximized-on-create = false;
          window-picker-icon = true;
          window-preview-caption = true;
          window-preview-close-button = true;
          workspace = true;
          workspace-background-corner-size = 0;
          workspace-peek = true;
          workspace-popup = true;
          workspace-switcher-should-show = true;
          workspace-switcher-size = 20;
          workspace-wrap-around = true;
          workspaces-in-app-grid = true;
          world-clock = false;
        };
      };
    };
}
