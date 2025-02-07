{
  cfg,
  pkgs,
  lib,
  extraLib,
  ...
}:

let
  inherit (extraLib) mkBoolDefaultTrue sanitizePath;
  inherit (lib)
    options
    filesystem
    types
    strings
    modules
    ;
in

let
  heicConverter = file: pkgs.callPackage ./heic-converter.nix { inherit file; };
  sanitizedImage = sanitizePath cfg.image;
in
{
  options = {
    enable = options.mkOption {
      type = types.bool;
      default = cfg.image != null;
    };

    image = options.mkOption {
      type = with types; nullOr (either path package);
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
      default =
        (filesystem.pathIsRegularFile sanitizedImage) && (strings.hasSuffix ".heic" sanitizedImage);
    };

    isStw = options.mkOption {
      type = types.bool;
      default =
        (filesystem.pathIsRegularFile sanitizedImage) && (strings.hasSuffix ".stw" sanitizedImage);
    };

    isStwDir = options.mkOption {
      type = types.bool;
      default =
        (filesystem.pathIsDirectory sanitizedImage)
        && (builtins.pathExists "${sanitizedImage}/wallpaper.stw");
    };

    isTimed = options.mkOption {
      type = types.bool;
      default = cfg.isHeic || cfg.isStw || cfg.isStwDir;
    };

    refreshOnUnlock = mkBoolDefaultTrue;
  };

  config =
    let
      convertedImage = if cfg.isHeic then heicConverter sanitizedImage else sanitizedImage;
      finalImage =
        if cfg.isHeic || cfg.isStwDir then "${convertedImage}/wallpaper.stw" else convertedImage;
    in
    modules.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.image != null;
          message = "Wallpaper image must be set!";
        }
      ];

      # Patch to fix the bug where settimed doesn't work for the dark theme of gnome
      # https://github.com/xyproto/wallutils/issues/44
      # TODO: Remove when the issue gets fixed
      quickPatches."wallutils" = [ ./fix-dark-mode.patch ];

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
            ${pkgs.wallutils}/bin/setwallpaper --mode ${cfg.mode} ${finalImage}
          '';
        };
        restartIfChanged = true;
        restartTriggers = [
          cfg.mode
          finalImage
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
              pushd "${builtins.dirOf finalImage}"
              ${pkgs.wallutils}/bin/settimed --mode ${cfg.mode} "${finalImage}"
            ''
          );
        };
        restartIfChanged = true;
        restartTriggers = [
          cfg.mode
          finalImage
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

      nx.rebuild.postRebuildActions =
        if cfg.isTimed then
          ''
            # Reload the wallpaper to avoid having to logout
            echo "Reloading dynamic wallpaper"
            systemctl --user restart wallutils-timed.service
          ''
        else
          ''
            # Stop any timed services that might still be running
            systemctl --user stop wallutils-timed.service >/dev/null 2>&1 || true
            systemctl --user stop wallutils-refresh.service >/dev/null 2>&1 || true

            # Reload the wallpaper to avoid having to logout
            echo "Reloading static wallpaper"
            systemctl --user restart wallutils-static.service
          '';

    };
}
