{
  lib,
  config,
  ...
}:

let
  inherit (lib) types;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf;

  cfg = config.my.symlinks;

  symlinkAttrType = types.submodule (
    { config, ... }:
    {
      options = {
        target = mkOption {
          description = "path relative to the symlink directory that should be symlinked";
          type = types.str;
          default = config._module.args.name;
        };

        destination = mkOption {
          description = "path anywhere on the system where the symlink should point to";
          type = types.str;
        };
      };
    }
  );

  mkSymlinkOption =
    description:
    mkOption {
      inherit description;
      type = types.attrsOf (types.either types.str symlinkAttrType);
      default = { };
    };
in

{
  options.my.symlinks = {
    enable = mkEnableOption "symlinking of home/xdg paths";

    xdgConfig = mkSymlinkOption "link a path relative to the XDG config directory (~/.config)";
    xdgCache = mkSymlinkOption "link a path relative to the XDG cache directory (~/.cache)";
    xdgData = mkSymlinkOption "link a path relative to the XDG data directory (~/.local/share)";
    xdgState = mkSymlinkOption "link a path relative to the XDG state directory (~/.local/state)";

    home = mkSymlinkOption "link a path relative to the home directory ($HOME aka /home/<user>)";
  };

  config.my.hm = mkIf cfg.enable (
    # `config` below is home-manager's config
    { config, ... }:
    let
      mapAttrsToSymlink = lib.mapAttrs (
        name: link:
        if lib.isString link then
          {
            # `link` is a string and so it contains the destination directly, and we get the target from the attribute name
            target = name;
            source = config.lib.file.mkOutOfStoreSymlink link;
          }
        else
          {
            # `link` is a symlinkAttrType with more options
            target = link.target;
            source = config.lib.file.mkOutOfStoreSymlink link.destination;
          }
      );

    in
    {
      xdg.configFile = mapAttrsToSymlink cfg.xdgConfig;
      xdg.cacheFile = mapAttrsToSymlink cfg.xdgCache;
      xdg.dataFile = mapAttrsToSymlink cfg.xdgData;
      xdg.stateFile = mapAttrsToSymlink cfg.xdgState;

      home.file = mapAttrsToSymlink cfg.home;
    }
  );
}
