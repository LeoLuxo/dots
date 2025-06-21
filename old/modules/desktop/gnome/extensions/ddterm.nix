{
  pkgs,
  config,
  constants,
  lib,
  ...
}:

{
  programs.dconf.enable = true;

  defaults.apps.terminal = lib.mkDefault "gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/ddterm --method com.github.amezin.ddterm.Extension.Toggle";

  ext.packages = with pkgs; [
    gnomeExtensions.ddterm
  ];

  home-manager.users.${config.ext.system.user.name} =
    { lib, ... }:
    {

      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ "ddterm@amezin.github.com" ];
        };

        "com/github/amezin/ddterm" = {
          ddterm-toggle-hotkey = [ ]; # Use the terminal shortcut instead
          background-color = "rgb(46,52,54)";
          background-opacity = 0.9;
          backspace-binding = "auto";
          bold-is-bright = false;
          panel-icon-type = "none";
          cursor-blink-mode = "on";
          cursor-shape = "ibeam";
          custom-font = "Mononoki Nerd Font 14";
          delete-binding = "auto";
          foreground-color = "rgb(211,215,207)";
          hide-when-focus-lost = true;
          hide-window-on-esc = true;
          palette = [
            "rgb(46,52,54)"
            "rgb(204,0,0)"
            "rgb(78,154,6)"
            "rgb(196,160,0)"
            "rgb(52,101,164)"
            "rgb(117,80,123)"
            "rgb(6,152,154)"
            "rgb(211,215,207)"
            "rgb(85,87,83)"
            "rgb(239,41,41)"
            "rgb(138,226,52)"
            "rgb(252,233,79)"
            "rgb(114,159,207)"
            "rgb(173,127,168)"
            "rgb(52,226,226)"
            "rgb(238,238,236)"
          ];
          pointer-autohide = true;
          shortcut-terminal-copy = [ "<Control>c" ];
          shortcut-terminal-paste = [ "<Control>v" ];
          shortcuts-enabled = true;
          theme-variant = "dark";
          use-system-font = false;
          use-theme-colors = false;
          window-maximize = false;
          window-position = "top";
          window-size = 0.75;
        };

      };
    };
}
