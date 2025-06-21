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
  options.my.packages =
    with lib2.options;
    mkOpt "Packages to pass directly to systemPackages." (types.listOf types.package) [ ];

  config.environment.systemPackages = lib.mkAliasDefinitions options.my.packages;
}
