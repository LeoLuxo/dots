{
  lib,
  options,
  ...
}:

let
  inherit (lib) types;
  inherit (lib.options) mkOption;
in
{
  options.my.packages = mkOption {
    description = "Packages to pass directly to systemPackages.";
    type = types.listOf types.package;
    default = [ ];
  };

  config.environment.systemPackages = lib.mkAliasDefinitions options.my.packages;
}
