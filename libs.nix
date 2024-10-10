{ nixpkgs, ... }@inputs:

with nixpkgs.lib;
with builtins;

rec {
  moduleSet = traceValSeq (findModules ./modules);

  imageSet = traceValSeq (
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
      traceValSeq (
        findAssets ./scripts [
          "sh"
          "nu"
          "py"
        ]
      )
    );

  # Recursively find modules/files in a given directory and map them to a logical name:
  # dir/a/b/module.ext = {a = {b = {module = path}}}
  # dir/a/b/module/default.ext = {a = {b = {module = path}}}
  findFiles =
    dir: extensions: allowDefault:
    let
      extRegex = "(${strings.concatStrings (strings.intersperse "|" extensions)})";
    in
    # concatLists (
    mapAttrs (
      name: type:
      let
        extMatch = (match "(.*)\\.${extRegex}" name);
      in
      if (type == "regular") && (extMatch != null) then
        # File matches "file.ext" pattern, include it
        [
          {
            name = elemAt extMatch 0;
            value = dir + "/${name}";
          }
        ]
      else if type == "directory" then
        if allowDefault && (readDir (dir + "/${name}")) ? "default.${extRegex}" then
          # Folder contains a "default.ext" file, include it (and don't search subfolders)
          [
            {
              inherit name;
              value = dir + "/${name}";
            }
          ]
        else
          # Recursively search subfolders
          [
            {
              inherit name;
              value = findFiles (dir + "/${name}") extensions allowDefault;
            }
          ]
      else
        [ ]
    ) (readDir dir);

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
        inherit moduleSet imageSet;
        scriptSet = scriptSet system;
      };
    };

}
