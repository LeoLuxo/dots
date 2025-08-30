{ inputs, lib2, ... }:
{
  mkHost =
    {
      hostname,
      user,
      nixosModules,
      homeModules,
    }:
    let
      # Additional args passed to ALL modules
      specialArgs = {
        inherit inputs lib2;
        inherit hostname user;
      };
    in
    inputs.nixpkgs.lib.nixosSystem ({
      # Additional args passed to nixos modules
      specialArgs = specialArgs // {
        inherit (inputs.self) nixosModules nixosProfiles;
      };

      modules = nixosModules ++ [
        inputs.home-manager.nixosModules.home-manager

        {
          nixpkgs.overlays = [
            inputs.self.overlays.pkgs
            inputs.self.overlays.builders
          ];

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs // {
              inherit (inputs.self) homeModules homeProfiles;
            };

            users.${user} = {
              imports = homeModules;
            };
          };
        }
      ];
    });

  mkHome =
    {
      hostname,
      user,
      modules,
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      # inherit pkgs;

      # Additional args passed to home-manager modules
      extraSpecialArgs = {
        inherit (inputs.self) homeModules homeProfiles;

        inherit inputs lib2;
        inherit hostname user;
      };

      modules = modules ++ [
        inputs.self.homeProfiles.nonNixos
      ];
    };
}
