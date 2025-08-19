{ inputs, lib, ... }:
{
  imports = [
    ./configuration.nix
    ./hardwareConfiguration.nix

    ./syncthing.nix
    ./wifi.nix

    # TODO: Remove
    (import "${inputs.self}/oldNewNixosModules" { inherit lib; }).default

    { system.stateVersion = "24.05"; }
  ];
}
