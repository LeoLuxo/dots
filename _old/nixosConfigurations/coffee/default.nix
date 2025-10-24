{
  inputs,
  lib,
  user,
  ...
}:
{
  imports = [
    # ./audio.nix
    ./backups.nix
    ./configuration.nix
    # ./hardwareConfiguration.nix
    # ./vr.nix

    # TODO: Remove
    (import "${inputs.self}/_old/oldNewNixosModules" { inherit lib; }).default

    { system.stateVersion = "24.05"; }
  ];
}
