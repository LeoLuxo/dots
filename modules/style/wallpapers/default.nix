{
  pkgs,
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.wallpaper;

  heicConverter =
    file:
    pkgs.callPackage (
      {
        lib,
        stdenv,
        wallutils,
        imagemagick,
      }:
      stdenv.mkDerivation (finalAttrs: {
        name = "nx-timed-wallpapers";
        src = file;

        nativeBuildInputs = [
          wallutils
          imagemagick
        ];

        # By default since src is a file, nix will try to unpack it
        dontUnpack = true;

        buildPhase = ''
          mkdir -p "$out"

          # Extract the individual images from the .heic as .jpg
          magick "$src" "$out/%02d.jpg"

          # Convert the .heic timing info to .stw and fix the hardcoded path in the .stw
          heic2stw "$src" > "$out/wallpaper.stw"
          # sed -i "s:/usr/share/backgrounds/:$out/:g" "$out/wallpaper.stw"
        '';
      })
    ) { };

in
{
  imports = [ ./wallutils-fix-dark-mode.nix ];

  options.wallpaper = {
    image = mkOption {
      type = types.path;
    };

    mode = mkOption {
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

    enable = mkOption {
      type = types.bool;
      default = builtins.isPath cfg.image;
    };

    isTimed = mkOption {
      type = types.bool;
      default = cfg.enable && (strings.hasSuffix ".heic" cfg.image);
    };

    refreshOnUnlock = mkOption {
      type = types.bool;
      default = true;
    };

    # packages = mkOption {
    #   type = types.submodule {
    #     options = {
    #       wallutils = mkOption {
    #         type = types.package;
    #         default = pkgs.wallutils;
    #         defaultText = "pkgs.wallutils";
    #       };
    #     };
    #   };
    # };
  };

  config = mkIf (traceValSeq cfg).enable (
    let
      wallpaper = traceValSeq (
        if cfg.isTimed then "${(heicConverter cfg.image)}/wallpaper.stw" else cfg.image
      );
    in
    {
      # Run wallutils settimed as a systemd service
      systemd.user.services.wallutils-timed = mkIf cfg.isTimed {
        unitConfig = {
          Description = "Wallutils timed wallpaper service";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        # The additional path is needed because wallutils looks at the programs currently in the path to decide how to set wallpapers
        path = [ "/run/current-system/sw" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = ''
            ${pkgs.wallutils}/bin/settimed --mode ${cfg.mode} "${wallpaper}"
          '';
        };
        wantedBy = [ "graphical-session.target" ];
      };

      # Sends a refresh signal to the wallutils service when an unlock is detected
      systemd.user.services.wallutils-refresh = mkIf (cfg.isTimed && cfg.refreshOnUnlock) {
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
    }
  );
}
