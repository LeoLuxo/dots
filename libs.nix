{ nixpkgs, ... }@inputs:

with nixpkgs.lib;
with builtins;

rec {
  # Recursively find modules in a given directory and map them to a logical name:
  # dir/.../module.nix
  # dir/.../module/default.nix
  findModules =
    dir:
    concatLists (
      attrValues (
        mapAttrs (
          name: type:
          if type == "regular" then
            [
              {
                name = elemAt (match "(.*)\\.nix" name) 0;
                value = dir + "/${name}";
              }
            ]
          else if (readDir (dir + "/${name}")) ? "default.nix" then
            [
              {
                inherit name;
                value = dir + "/${name}";
              }
            ]
          else
            findModules (dir + "/${name}")
        ) (readDir dir)
      )
    );

  # Recursively find assets in a given directory and map them to a logical name:
  # dir/.../asset.ext1
  # dir/.../asset.ext2
  findAssets =
    dir: extensions:
    let
      ext_regex = "(${strings.concatStrings (strings.intersperse "|" extensions)})";
    in
    concatLists (
      attrValues (
        mapAttrs (
          name: type:
          if type == "regular" then
            [
              {
                name = elemAt (match "(.*)\\.${ext_regex}" name) 0;
                value = dir + "/${name}";
              }
            ]
          else
            findAssets (dir + "/${name}") extensions
        ) (readDir dir)
      )
    );

  # Function to create a nixos host config
  mkHost =
    {
      user,
      hostName,
      system,
      hostModule,
    }:
    nixosSystem {
      inherit system;
      modules = [
        hostModule
        ./secrets.nix
      ];
      specialArgs = inputs // {
        # Constants
        inherit user hostName system;
        # Helper libs
        inherit moduleSet iconSet;
        scriptSet = scriptSet system;
      };
    };

  moduleSet = listToAttrs (findModules ./modules);

  iconSet = listToAttrs (
    findAssets ./assets [
      "png"
      "jpg"
      "jpeg"
      "gif"
      "svg"
      "ico"
      "icns"
    ]
  );

  scriptSet =
    system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    mapAttrs (name: value: pkgs.writeShellScriptBin name (builtins.readFile value)) (
      listToAttrs (
        findAssets ./scripts [
          "sh"
          "nu"
          "py"
        ]
      )
    );

}
