{ inputs, ... }:
{
  imports = [
    ./audio.nix
    ./backups.nix
    ./configuration.nix
    ./hardwareConfiguration.nix
    ./syncthing.nix

    ./oldconfig.nix

    inputs.self.nixosModules.default

    { system.stateVersion = "24.05"; }
  ];
}
