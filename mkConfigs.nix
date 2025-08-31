args@{
  inputs,
  lib,
  lib2,
  ...
}:

let
  nixos = import ./nixos args;
  home = import ./home args;
in
{
  mkNixosConfig =
    {
      hostname,
      users,
      module,
      autologin ? null,
    }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs lib2;
        inherit hostname users autologin;
        nixosProfiles = nixos.profiles;
      };

      modules =
        [
          # Include the main module
          module

          inputs.home-manager.nixosModules.home-manager

          # Set up home manager
          {
            home-manager = {
              useGlobalPkgs = false;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs lib2;
                inherit hostname;
                homeProfiles = home.profiles;
              };

              # Set up all the manually-defined users into home manager
              users = lib.concatMapAttrs (username: userCfg: {
                ${username} = {
                  imports =
                    [
                      # Include the main module for the user
                      userCfg.module

                      # Set up the current user for home-manager, as there's not really any way to pass along the current user to modules other than `config.home.username`
                      { home.username = username; }
                    ]
                    # Auto-include all custom home-manager modules
                    ++ (lib.attrValues home.modules);
                };
              }) users;
            };
          }
        ]

        # Auto-include all custom nixos modules
        ++ (lib.attrValues nixos.modules);
    };

  mkHomeManagerConfigs =
    users:
    lib.concatMapAttrs (username: userCfg: {
      # Additional args passed to home-manager modules
      extraSpecialArgs = {
        inherit (inputs.self) homeModules homeProfiles;
        inherit inputs lib2;
      };

      modules =
        [
          # Include the main module for the user
          userCfg.module

          # Auto-include the profile for non-nixos machines
          inputs.self.homeProfiles.nonNixos

          { home.username = username; }
        ]

        # Auto-include all custom home-manager modules
        ++ (lib.attrValues inputs.self.homeModules);
    }) users;

  # mkHost =
  #   {
  #     hostname,
  #     user,
  #     nixosModules,
  #     homeModules,
  #   }:
  #   let
  #     # Additional args passed to ALL modules (both hm and nixos)
  #     specialArgs = {
  #       inherit inputs lib2;
  #       inherit hostname user;
  #     };
  #   in
  #   inputs.nixpkgs.lib.nixosSystem ({
  #     # Additional args passed to nixos modules
  #     specialArgs = specialArgs // {
  #       inherit (inputs.self) nixosModules nixosProfiles;
  #     };

  #     modules =
  #       nixosModules
  #       # Auto-include all custom nixos modules
  #       ++ (lib.attrValues inputs.self.nixosModules)
  #       # Include home-manager and its modules
  #       ++ [
  #         inputs.home-manager.nixosModules.home-manager

  #         {
  #           nixpkgs.overlays = [
  #             inputs.self.overlays.pkgs
  #             inputs.self.overlays.builders
  #           ];

  #           home-manager = {
  #             # useGlobalPkgs = true;
  #             useUserPackages = true;
  #             extraSpecialArgs = specialArgs // {
  #               inherit (inputs.self) homeModules homeProfiles;
  #             };

  #             users.${user} = {
  #               imports =
  #                 homeModules
  #                 # Auto-include all custom home-manager modules
  #                 ++ (lib.attrValues inputs.self.homeModules);
  #             };
  #           };
  #         }
  #       ];
  #   });

  # mkHome =
  #   {
  #     hostname,
  #     user,
  #     modules,
  #   }:
  #   inputs.home-manager.lib.homeManagerConfiguration {
  #     # inherit pkgs;

  #     # Additional args passed to home-manager modules
  #     extraSpecialArgs = {
  #       inherit (inputs.self) homeModules homeProfiles;

  #       inherit inputs lib2;
  #       inherit hostname user;
  #     };

  #     modules =
  #       modules
  #       # Auto-include the profile for non-nixos machines
  #       ++ [
  #         inputs.self.homeProfiles.nonNixos
  #       ]
  #       # Auto-include all custom home-manager modules
  #       ++ (lib.attrValues inputs.self.homeModules);
  #   };
}
