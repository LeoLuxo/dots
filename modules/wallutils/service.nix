{
  config,
  lib,
  pkgs,
  extra-libs,
  ...
}:

let
  inherit (extra-libs) mkEnableOption;
  inherit (lib)
    options
    types
    modules
    strings
    ;
in

let
  cfg = config.services.wallutils;

  modeOption = options.mkOption {
    type = types.either (types.enum [
      "stretch"
      "center"
      "tile"
      "scale"
      "zoom"
      "fill"
    ]) types.str;
    default = "zoom";
    description = "Wallpaper mode";
  };
in
{

  options.services.wallutils = {
    enable = mkEnableOption "Wallutils automatic wallpaper tool";

    package = options.mkOption {
      type = types.package;
      default = pkgs.wallutils;
      defaultText = "pkgs.wallutils";
    };

    timed = options.mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption "Systemd service for the timed wallpaper";

          refreshOnUnlock = options.mkOption {
            type = types.bool;
            default = true;
          };

          theme = options.mkOption {
            type = types.path;
            example = "mojave-timed";
            description = ''
              Name or path of the timed wallpaper.
              If the filename contains an extension, then it must be one of
              <code>.xml</code> or <code>.stw</code>.
            '';
          };

          mode = modeOption;
        };
      };
      default = { };
      example = options.literalExpression ''
        {
          enable = true;
          theme = "''${pkgs.gnome.gnome-backgrounds}/share/backgrounds/gnome/adwaita-timed.xml";
          mode = "stretch";
        }
      '';
    };

    static = options.mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption "Systemd service to set the wallpaper";

          image = options.mkOption {
            type = types.str;
            example = "\${config.home.homeDirectory}/Pictures/my-wallpaper.png";
            description = "Path or URL of the wallpaper";
          };

          downloadDir = options.mkOption {
            type = types.nullOr types.path;
            default = null;
            example = "\${config.home.homeDirectory}/Downloads";
            description = "Path to the download directory for URL wallpapers";
          };

          mode = modeOption;
        };
      };
      default = { };
      example = options.literalExpression ''
        {
          enable = true;
          image = "https://source.unsplash.com/3840x2160/?mountains";
          mode = "stretch";
          downloadDir = "/tmp/wallpapers";
        }
      '';
    };
  };

  config = modules.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.timed.enable && cfg.static.enable);
        message =
          "Wallutils timed and static wallpapers are mutually exclusive."
          + " Either one may be enable, not both.";
      }
    ];

    systemd.user.services.wallutils-timed = modules.mkIf cfg.timed.enable {
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
          ${cfg.package}/bin/settimed --mode ${cfg.timed.mode} "${cfg.timed.theme}"
        '';
      };
      wantedBy = [ "graphical-session.target" ];
    };

    # Sends a refresh signal to the wallutils service when an unlock is detected
    systemd.user.services.wallutils-refresh = modules.mkIf cfg.timed.refreshOnUnlock {
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

    systemd.user.services.wallutils-static = modules.mkIf cfg.static.enable {
      unitConfig = {
        Description = "Wallutils static wallpaper service";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      serviceConfig = {
        Type = "oneshot";
        Environment = "PATH=/run/current-system/sw/bin/";
        ExecStart = strings.concatStringsSep " " [
          "${cfg.package}/bin/setwallpaper"
          "--mode ${cfg.static.mode}"
          (strings.optionalString (
            cfg.static.downloadDir != null
          ) "--download ${strings.escapeShellArg cfg.static.downloadDir}")
          "${cfg.static.image}"
        ];
      };
      wantedBy = [ "graphical-session.target" ];
    };
  };
}
