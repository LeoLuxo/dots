{
  lib,
  lib2,
  pkgs,
  config,
  ...
}:

let
  inherit (lib) options types;
  inherit (lib2) mkSubmodule;

  cfg = config.gnome;
in
{

  options.gnome = {
    lockscreen = mkSubmodule {
      wallpaper = options.mkOption {
        type = types.nullOr (types.either types.path types.package);
        default = null;
      };

      blur = options.mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
      };
    };
  };

  config = lib.mkIf (cfg.lockscreen.wallpaper != null) {
    # Copy over the wallpaper for the lockscreen and blur it if relevant
    environment.etc."lockscreen".source =
      if cfg.lockscreen.blur == null then
        cfg.lockscreen.wallpaper
      else
        (pkgs.runCommand "blur-lockscreen" { } ''
          ${lib.getExe pkgs.imagemagick} ${cfg.lockscreen.wallpaper} -blur 0x${builtins.toString cfg.lockscreen.blur} $out
        '');

    # Add the patch to use our wallpaper on the lockscreen
    nixpkgs.overlays = [
      (self: super: {
        gnome-shell = super.gnome-shell.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [
            ./bg.patch
          ];
        });
      })
    ];
  };
}
