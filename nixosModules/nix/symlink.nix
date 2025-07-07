{
  lib,
  config,
  inputs,
  ...
}:

let
  inherit (lib) types;
  inherit (lib.my) enabled mkAttrs mkAttrs';
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf;

  cfg = config.my.symlinks;

  mkSymlinkOption =
    description:
    # mkAttrs {
    #   description = "${description} (${path})";
    #   options =
    #     { name, ... }:
    #     {
    #       destinationPath = mkOption {
    #         description = "path anywhere on the system where the symlink should point to";
    #         type = types.str;
    #       };
    #     };
    # };
    mkOption {
      inherit description;
      type = types.attrsOf types.str;
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
    { config, ... }:
    let
      mapAttrsToSymlink = lib.mapAttrs (
        name: destination: {
          target = name;
          source = config.lib.file.mkOutOfStoreSymlink destination;
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
