args@{
  inputs,
  lib,
  lib2,
  hosts,
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
      nixosConfig,
      users ? { },
      autologin ? null,
      ...
    }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs lib2;
        inherit
          hostname
          users
          autologin
          hosts
          ;
        nixosProfiles = nixos.profiles;
        host = hosts.${hostname};
      };

      modules =
        [
          # Include the main module
          nixosConfig

          inputs.home-manager.nixosModules.home-manager

          # Set up home manager
          {
            home-manager = {
              useGlobalPkgs = false;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs lib2;
                inherit hostname hosts;
                homeProfiles = home.profiles;
                host = hosts.${hostname};
                
              };

              # Set up all the manually-defined users into home manager
              users = lib.concatMapAttrs (username: userCfg: {
                ${username} = {
                  imports =
                    [
                      # Include the main module for the user
                      userCfg.homeConfig

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

  # mkHomeManagerConfig =
  #   username:
  #   { homeConfig, ... }:
  #   inputs.home-manager.lib.homeManagerConfiguration {
  #     # Additional args passed to home-manager modules
  #     extraSpecialArgs = {
  #       inherit (inputs.self) homeModules homeProfiles;
  #       inherit inputs lib2;
  #       inherit hosts;
  #     };

  #     modules =
  #       [
  #         # Include the main module for the user
  #         homeConfig

  #         # Auto-include the profile for non-nixos machines
  #         inputs.self.homeProfiles.nonNixos

  #         { home.username = username; }
  #       ]

  #       # Auto-include all custom home-manager modules
  #       ++ (lib.attrValues inputs.self.homeModules);
  #   };
}
