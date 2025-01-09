{
  pkgs,
  config,
  lib,
  extra-libs,
  ...
}:

let
  inherit (extra-libs) sanitizePath mkQuickPatch mkBoolDefaultTrue;
  inherit (lib)
    options
    filesystem
    types
    strings
    modules
    ;
in

let
  cfg = config.wallpaper;

  heicConverter = file: pkgs.callPackage ./heic-converter.nix { inherit file; };

  hasExtension =
    extension: fileName:
    (builtins.elemAt (builtins.match ".*\\.([a-zA-Z0-9]+)" fileName) 0) == extension;
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
        (filesystem.pathIsRegularFile cfg.image)
        && (hasExtension ".heic" (lib.traceValSeq (builtins.toString cfg.image)));
    };

    isStw = options.mkOption {
      type = types.bool;
      default =
        (filesystem.pathIsRegularFile cfg.image) && (hasExtension ".stw" (builtins.toString cfg.image));
    };

    isTimed = options.mkOption {
      type = types.bool;
      default = cfg.isHeic || cfg.isStw;
    };

    refreshOnUnlock = mkBoolDefaultTrue;
  };

  config =
    let
      sanitizedImage = lib.traceValSeq (sanitizePath (lib.traceValSeq cfg.image));

      wallpaper = if cfg.isHeic then "${heicConverter sanitizedImage}/wallpaper.stw" else sanitizedImage;
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
