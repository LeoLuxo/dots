{ inputs, ... }:
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

    # Add my custom libs, accessible under `pkgs.lib2`
    (final: prev: {
      lib2 = import ../lib {
        lib = prev.lib;
        pkgs = prev;
      };
    })
  ];

  mkHost =
    user: hostname: module:
    inputs.nixpkgs.lib.nixosSystem (
      let
        # TODO remove
        system = "x86_64-linux";

        defaultConstants = rec {
          # userHome = "/home/${user}";
          nixosPath = "/etc/nixos";
          secretsPath = "/home/lili/misc/secrets";

          nixosRepoPath = (nixosPath + "/dots");
        };

        constants = defaultConstants // {
          inherit hostname system;
        };

        extraLib = import ../old/libs.nix {
          inherit inputs constants;
        };

        nixosModulesOld = extraLib.findFiles {
          dir = ../old/modules;
          extensions = [ "nix" ];
          defaultFiles = [ "default.nix" ];
        };
      in
      {
        modules = [
          module
          { nixpkgs.overlays = hostOverlays; }
        ];

        # Additional args passed to the modules
        specialArgs = {
          inherit inputs hostname user;

          # TODO remove
          inherit
            extraLib
            nixosModulesOld
            constants
            system
            ;
        };
      }
    );

in
{
  # Personal desktop computer
  coffee = mkHost "lili" "coffee" ./hosts/coffee;

  # Surface Pro 7 laptop
  pancake = mkHost "lili" "pancake" ./hosts/pancake;
}
