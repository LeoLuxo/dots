{ inputs, lib, ... }:

final: prev:
let
  mkPkgsOverlay =
    nixpkgs:
    import nixpkgs {
      inherit prev;
      system = prev.system;
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
  "25-05" = mkPkgsOverlay inputs.nixpkgs-25-05;
  "24-11" = mkPkgsOverlay inputs.nixpkgs-24-11;
  "24-05" = mkPkgsOverlay inputs.nixpkgs-24-05;

  "custom" =
    final: prev:
    lib.packagesFromDirectoryRecursive {
      inherit (prev) callPackage;
      directory = ./packages;
    };
}
