inputs:

with inputs.nixpkgs.lib;

rec {
  # Recursively find modules in a given directory and map them to a logical name:
  # dir/.../module.nix
  # dir/.../module/default.nix
  findModules =
    dir:
    builtins.concatLists (
      builtins.attrValues (
        builtins.mapAttrs (
          name: type:
          if type == "regular" then
            [
              {
                name = builtins.elemAt (builtins.match "(.*)\\.nix" name) 0;
                value = dir + "/${name}";
              }
            ]
          else if (builtins.readDir (dir + "/${name}")) ? "default.nix" then
            [
              {
                inherit name;
                value = dir + "/${name}";
              }
            ]
          else
            findModules (dir + "/${name}")
        ) (builtins.readDir dir)
      )

    );

  globalModules = traceValSeq (builtins.listToAttrs (findModules ./modules));

  # Function to create a nixos host config
  mkHost =
    {
      user,
      system,
      hostModule,
    }:
    nixosSystem {
      inherit system;
      modules = [
        hostModule
        ./secrets.nix
      ];
      specialArgs = extraInputs // {
        inherit user system;
      };
    };

  extraInputs = inputs // {
    inherit globalModules mkHost;
  };
}
