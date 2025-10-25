{
  inputs,
  lib,
  user,
  ...
}:
{
  imports = [
    ./configuration.nix

    # TODO: Remove
    (import "${inputs.self}/_old/oldNewNixosModules" { inherit lib; }).default

    { system.stateVersion = "24.05"; }
  ];
}
