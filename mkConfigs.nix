args@{
  inputs,
  lib,
  lib2,
  hosts,
  ...
}:

let
  modules = import ./modules args;
  profiles = import ./profiles args;
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
        inherit profiles;
        host = hosts.${hostname};
        user = (lib.elemAt users 0).username;

        # TODO: remove
        nixosModules = import ./_old/nixosModules { inherit inputs lib lib2; };
      };

      modules =
        [
          # Include the main module
          nixosConfig
        ]
        # Auto-include all custom nixos modules
        ++ (lib.attrValues modules);
    };
}
