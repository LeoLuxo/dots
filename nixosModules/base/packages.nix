{
  lib,
  ...
}:

{
  # Alias for convenience and abstraction
  imports = [
    (lib.mkAliasOptionModule [ "my" "packages" ] [ "environment" "systemPackages" ])
  ];
}
