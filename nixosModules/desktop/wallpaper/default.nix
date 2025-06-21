{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib)
    filesystem
    types
    strings
    modules
    ;
  cfg = config.my.desktop.wallpaper;
in

let
  heicConverter = file: pkgs.callPackage ./heic-converter.nix { inherit file; };
  sanitizedImage = lib2.sanitizePath cfg.image;
in
{
  options.my.desktop.wallpaper = with lib2.options; {
    enable = mkOpt "Enable the wallpaper module" types.bool (cfg.image != null);

    image = mkNullOr "The image for the wallpaper" (types.either path package);

    mode = mkEnum "The filling mode of the wallpaper" [
      "stretch"
      "center"
      "tile"
      "scale"
      "zoom"
      "fill"
    ] "zoom";

    isHeic = mkOpt "Whether the wallpaper is a HEIC image" types.bool (
      (filesystem.pathIsRegularFile sanitizedImage) && (strings.hasSuffix ".heic" sanitizedImage)
    );

    isStw = mkOpt "Whether the wallpaper is an STW file" types.bool (
      (filesystem.pathIsRegularFile sanitizedImage) && (strings.hasSuffix ".stw" sanitizedImage)
    );

    isStwDir = mkOpt "Whether the wallpaper is a directory containing an STW file" types.bool (
      (filesystem.pathIsDirectory sanitizedImage)
      && (builtins.pathExists "${sanitizedImage}/wallpaper.stw")
    );

    isTimed = mkOpt "Whether the wallpaper changes over time" types.bool (
      cfg.isHeic || cfg.isStw || cfg.isStwDir
    );

    refreshOnUnlock =
      mkOpt "Whether to refresh the wallpaper when the screen is unlocked" types.bool
        true;
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
