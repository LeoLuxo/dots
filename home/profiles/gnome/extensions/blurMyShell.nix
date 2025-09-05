{
  config,
  pkgs,
  lib,
  lib2,
  ...
}:

let
  inherit (lib2) mkSubmodule;
  inherit (lib) options types;

  cfg = config.gnome.blur;
in

{
  options.gnome.blur = {
    enable = lib.mkOption {
      type = types.bool;
      default = true;
    };

    appBlur = mkSubmodule {
      enable = options.mkEnableOption "enable app blur";
    };

    hacksLevel = options.mkOption {
      description = "Set the hacks level for the Blur My Shell extension. Higher levels may improve performance but could introduce visual artifacts.";
      type = types.enum [
        "high performance"
        "default"
        "no artifact"
      ];
      default = "default";
    };
  };

  config = {
    home.packages = with pkgs; [
      gnomeExtensions.blur-my-shell
    ];

    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [ "blur-my-shell@aunetx" ];
      };

      "org/gnome/shell/extensions/blur-my-shell" = {
        hacks-level =
          {
            "high performance" = 0;
            "default" = 1;
            "no artifact" = 2;
          }
          .${cfg.hacksLevel};

        settings-version = 2;
      };

      "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
        blur = true;
        brightness = 0.6;
        sigma = 30;
      };

      "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
        blur = false;
        brightness = 0.6;
        pipeline = "pipeline_default_rounded";
        sigma = 30;
        static-blur = true;
        style-dash-to-dock = 0;
      };

      "org/gnome/shell/extensions/blur-my-shell/hidetopbar" = {
        compatibility = false;
      };

      "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
        pipeline = "pipeline_default";
      };

      "org/gnome/shell/extensions/blur-my-shell/overview" = {
        blur = true;
        pipeline = "pipeline_default";
        style-components = 1;
      };

      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        blur = true;
        brightness = 0.6;
        force-light-text = false;
        override-background-dynamically = false;
        pipeline = "pipeline_default";
        sigma = 30;
        static-blur = true;
        style-panel = 0;
        unblur-in-overview = true;
      };

      "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
        blur = true;
        pipeline = "pipeline_default";
      };

      "org/gnome/shell/extensions/blur-my-shell/window-list" = {
        brightness = 1.0;
        sigma = 30;
      };

      "org/gnome/shell/extensions/blur-my-shell/applications" = {
        blacklist = [
          "Plank"
          "com.desktop.ding"
          "Conky"
          "firefox"
        ];
        blur = cfg.appBlur.enable;
        dynamic-opacity = true;
        enable-all = true;
        brightness = 0.4;
        opacity = 180;
      };
    };
  };
}
