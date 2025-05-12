{
  lib,
  options,
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib) types;
in
{
  options.ext.packages =
    with lib2.options;
    mkOpt "Packages to pass directly to home-manager." (types.listOf types.package) [ ];

  config.environment.systemPackages = lib.mkAliasDefinitions options.ext.packages;
}
