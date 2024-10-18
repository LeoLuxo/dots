{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.wallpaper;
in
{
  options.wallpaper = {
    image = mkOption {
      type = types.nullOr types.path;
      default = null;
    };

    enable = mkOption {
      type = types.bool;
      default = cfg.image != null;
    };

    is-timed = mkOption {
      type = types.bool;
      default = cfg.enable && (strings.hasSuffix ".heic" cfg.image);
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

  config = mkIf (traceValSeq cfg).enable {
    # wallpaper.is-static = !cfg.is-timed;
  };
}
