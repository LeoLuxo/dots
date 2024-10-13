{ nixpkgs, ... }@inputs:

with nixpkgs.lib;
with builtins;

rec {
  directories = {
    modules = findFiles ./modules [ "nix" ] true;

    images = findFiles ./assets [
      "png"
      "jpg"
      "jpeg"
      "gif"
      "svg"
    ] false;

    icons = findFiles ./assets [
      "ico"
      "icns"
    ] false;

    scripts = findFiles ./scripts [
      "sh"
      "nu"
      "py"
    ] true;
  };

  scriptBin =
    system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    mapAttrs (name: value: pkgs.writeShellScriptBin name (builtins.readFile value)) directories.scripts;

  # Recursively find modules in a given directory and map them to a logical name:
  # dir/.../module.ext
  # dir/.../module/default.ext
  findFiles =
    dir: extensions: allowDefault:
    let
      extRegex = "(${strings.concatStrings (strings.intersperse "|" extensions)})";
      findFilesInner =
        dir:
        concatLists (
          attrValues (
            mapAttrs (
              name: type:
              let
                extMatch = (match "(.*)\\.${extRegex}" name);
              in
              # If regular file, then add it to the file list only if the extension regex matches
              if type == "regular" then
                if extMatch == null then
                  [ ]
                else
                  [
                    {
                      name = elemAt extMatch 0;
                      value = dir + "/${name}";
                    }
                  ]
              # If directory, ...
              else if type == "directory" then
                let
                  # ... then search for a default.ext file
                  files = readDir (dir + "/${name}");
                  defaultFiles = map (ext: "default.${ext}") extensions;
                  hasDefault = any (defaultFile: files ? ${defaultFile}) defaultFiles;
                in
                # if it exists, add the directory to our file list
                if allowDefault && hasDefault then
                  [
                    {
                      inherit name;
                      value = dir + "/${name}";
                    }
                  ]
                else
                  # otherwise search recursively in the directory
                  findFilesInner (dir + "/${name}")
              else
                # any other file types we ignore (i.e. symlink and unknown)
                [ ]
            ) (readDir dir)
          )
        );
    in
    listToAttrs (findFilesInner dir);

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
        inherit directories;
        scriptBin = scriptBin system;
      };
    };

}
