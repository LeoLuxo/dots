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
      nixosConfig,
      hostname,
      users ? { },
      autologin ? null,
      ...
    }@extras:
    # If a `user` is specified, that user must be defined in `users`
    assert !extras ? "user" || users ? ${extras.user};

    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs lib2;
        inherit profiles;
        host = hosts.${hostname};

        # TODO: remove
        nixosModules = import ./_old/nixosModules { inherit inputs lib lib2; };
      } // extras;

      modules =
        [
          # Include the main module
          nixosConfig
        ]
        # Auto-include all custom nixos modules
        ++ (lib.attrValues modules);
    };
}
