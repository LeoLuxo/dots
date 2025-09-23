{
  inputs,
  lib,
  lib2,
  ...
}:
let
  mkPkgsOverlay =
    name: nixpkgs:
    (final: prev: {
      ${name} = import nixpkgs {
        inherit prev;
        system = prev.system;
        config.allowUnfree = true;
      };
    });

  hostOverlays = [
    # Some extra instances of pkgs, so that my nixosConfigurations can pin packages more easily.
    # Can be used via:
    # ```
    #   packages = [ pkgs.unstable.firefox ];
    # ```
    (mkPkgsOverlay "stable" inputs.nixpkgs-stable)
    (mkPkgsOverlay "unstable" inputs.nixpkgs-unstable)
    (mkPkgsOverlay "25-05" inputs.nixpkgs-25-05)
    (mkPkgsOverlay "24-11" inputs.nixpkgs-24-11)
    (mkPkgsOverlay "24-05" inputs.nixpkgs-24-05)

    # Add my custom builders, accessible under `pkgs.<builder>`
    (
      final: prev:
      import ../../builders.nix {
        inherit lib lib2;
        pkgs = prev;
      }
    )
  ];

  mkHost =
    {
      user,
      hostname,
      module,
    }:
    inputs.nixpkgs.lib.nixosSystem ({
      modules = [
        module

        { nixpkgs.overlays = hostOverlays; }
      ];

      # Additional args passed to the modules
      specialArgs = {
        inherit
          inputs
          lib2
          hostname
          user
          ;

        inherit (inputs.self) nixosModules;
      };
    });

in
import ./hosts.nix mkHost
