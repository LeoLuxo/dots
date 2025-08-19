{ inputs, lib, ... }:
{
  imports = [
    ./audio.nix
    ./backups.nix
    ./configuration.nix
    ./hardwareConfiguration.nix
    ./syncthing.nix

    ./oldconfig.nix

    (import "${inputs.self}/oldNewNixosModules" { inherit lib; }).default

    { system.stateVersion = "24.05"; }
  ];
}
