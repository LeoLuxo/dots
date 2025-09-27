{ inputs, lib, ... }:
{
  imports = [
    ./configuration.nix

    ./wifi.nix

    # TODO: Remove
    (import "${inputs.self}/_old/oldNewNixosModules" { inherit lib; }).default

    { system.stateVersion = "24.05"; }
  ];

  # Add our custom overlays
  nixpkgs.overlays = [
    inputs.self.overlays.extraPkgs
    inputs.self.overlays.builders
    inputs.self.overlays.packages
  ];
}
