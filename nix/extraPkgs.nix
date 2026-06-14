{ inputs, lib, ... }:

final: prev:
let
  mkPkgsOverlay =
    nixpkgs:
    import nixpkgs {
      inherit prev;
      hostPlatform = prev.hostPlatform;
      config.allowUnfree = true;
    };
in
{
  # Some extra instances of pkgs, so that my nixosConfigurations can pin packages more easily.
  # Example usage:
  # ```
  #   packages = [ pkgs.unstable.firefox ];
  # ```
  "stable" = mkPkgsOverlay inputs.nixpkgs-stable;
  "unstable" = mkPkgsOverlay inputs.nixpkgs-unstable;
  "pinned" = mkPkgsOverlay inputs.nixpkgs-pinned;
  "25-11" = mkPkgsOverlay inputs.nixpkgs-25-11;
  "25-05" = mkPkgsOverlay inputs.nixpkgs-25-05;

  # Expose the packages defined in ./packages in `pkgs.custom` because my modules can't use the exposed packages from the flake directly
  "custom" = lib.packagesFromDirectoryRecursive {
    # Pin those to a specific pkgs toolchain
    inherit (final."pinned") callPackage;
    directory = ./packages;
  };
}
