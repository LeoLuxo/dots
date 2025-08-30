{ ... }:
{
  # Home Manager has an option to automatically set some environment variables that will ease usage of software installed with nix on non-NixOS linux (fixing local issues, settings XDG_DATA_DIRS, etc.)
  targets.genericLinux.enable = true;

  # Allow unfree packages (when using home-manager as a nixos module, this will be automatically transferred from `useGlobalPkgs`)
  nixpkgs.config.allowUnfree = true;
}
