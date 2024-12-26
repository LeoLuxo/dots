{
  pkgs,
  config,
  lib,
  extra-libs,
  ...
}:

let
  inherit (extra-libs) sanitizePath mkQuickPatch;
  inherit (lib)
    options
    types
    strings
    modules
    ;
in

let
  cfg = config.wallpaper;

  heicConverter = file: pkgs.callPackage ./heic-converter.nix { inherit file; };
in
{
  imports = [
    # Patch to fix the bug where settimed doesn't work for the dark theme of gnome
    # https://github.com/xyproto/wallutils/issues/44
    # TODO: Remove when the issue gets fixed
    (mkQuickPatch {
      package = "wallutils";
      patches = [ ./fix-dark-mode.patch ];
    })
  ];

  options.wallpaper = {
    enable = options.mkOption {
      type = types.bool;
      default = cfg.image != null;
    };

    image = options.mkOption {
      type = types.nullOr types.path;
      default = null;
    };

    mode = options.mkOption {
      type = types.enum [
        "stretch"
        "center"
        "tile"
        "scale"
        "zoom"
        "fill"
      ];
      default = "zoom";
      description = "Wallpaper mode";
    };

    isHeic = options.mkOption {
      type = types.bool;
      default = strings.hasSuffix ".heic" cfg.image;
    };

    isTimed = options.mkOption {
      type = types.bool;
      default = cfg.isHeic || (builtins.pathExists "${cfg.image}/wallpaper.stw");
    };

    refreshOnUnlock = options.mkOption {
      type = types.bool;
      default = true;
    };
  };

  config =
    let
      image = sanitizePath cfg.image;

      wallpaper =
        if cfg.isTimed then
          "${if cfg.isHeic then (heicConverter image) else image}/wallpaper.stw"
        else
          image;
    in
    modules.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.image != null;
          message = "Wallpaper image must be set!";
        }
      ];

      # Handle static wallpapers
      systemd.user.services."wallutils-static" = modules.mkIf (!cfg.isTimed) {
        unitConfig = {
          Description = "Wallutils static wallpaper service";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        # The additional path is needed because wallutils looks at the programs currently in the path to decide how to set wallpapers
        path = [ "/run/current-system/sw" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''
            ${pkgs.wallutils}/bin/setwallpaper --mode ${cfg.mode} ${wallpaper}
          '';
        };
        restartIfChanged = true;
        restartTriggers = [
          cfg.mode
          wallpaper
        ];
        wantedBy = [ "graphical-session.target" ];
      };

      # Handle dynamic wallpapers
      # Run wallutils settimed as a systemd service
      systemd.user.services."wallutils-timed" = modules.mkIf cfg.isTimed {
        unitConfig = {
          Description = "Wallutils timed wallpaper service";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        # The additional path is needed because wallutils looks at the programs currently in the path to decide how to set wallpapers
        path = [ "/run/current-system/sw" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = (
            pkgs.writeShellScript "wallutils-timed" ''
              pushd "${builtins.dirOf wallpaper}"
              ${pkgs.wallutils}/bin/settimed --mode ${cfg.mode} "${wallpaper}"
            ''
          );
        };
        restartIfChanged = true;
        restartTriggers = [
          cfg.mode
          wallpaper
        ];
        wantedBy = [ "graphical-session.target" ];
      };

      # Sends a refresh signal to the wallutils service when an unlock is detected
      systemd.user.services."wallutils-refresh" = modules.mkIf (cfg.isTimed && cfg.refreshOnUnlock) {
        unitConfig = {
          Description = "Wallutils refresher";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        path = [ "/run/current-system/sw" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = (
            pkgs.writeShellScript "wallutils-refresh" ''
              gdbus monitor -y -d org.freedesktop.login1 |
                grep --line-buffered -o 'Session.Unlock ()' |
                while read -r; do
                  echo "Unlock detected"
                  pkill settimed -USR1
                done
            ''
          );
        };
        wantedBy = [ "graphical-session.target" ];
      };
    };
}
