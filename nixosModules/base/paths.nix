{
  config,
  lib,
  ...
}:

let
  inherit (lib) types;
  inherit (lib.my) notNullOr;
  inherit (lib.options) mkOption;
in

let
  mkPathEntry =
    args:
    mkOption {
      type = types.nullOr types.path;
      default = null;
    }
    // args;
in
{
  options.my.paths = {
    "home" = mkPathEntry {
      description = "the default home folder; the user's home if this nixos-config is configured as a single-user system (`/home/<user>` by default), `/root` otherwise";
      default = notNullOr config.my.user.home "/root";
    };

    "nixos" = mkPathEntry {
      description = "the nixos config folder";
      default = "/etc/nixos";
    };

    "nixosRepo" = mkPathEntry {
      description = "the working copy of this repository";
    };
  };
}
