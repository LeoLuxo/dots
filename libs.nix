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

    icons = findFiles ./assets/icons [
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
      ignore = name: {
        name = "";
        value = null;
      };

      findFilesRecursive =
        dir:
        attrsets.filterAttrs (n: v: v != null) (
          attrsets.mapAttrs' (
            fileName: type:
            let
              extMatch = (match "(.*)\\.${extRegex}" fileName);
              filePath = dir + "/${fileName}";
            in
            # If regular file, then add it to the file list only if the extension regex matches
            if type == "regular" then
              if extMatch == null then
                ignore fileName
              else
                {
                  name = elemAt extMatch 0;
                  value = filePath;
                }
            # If directory, ...
            else if type == "directory" then
              let
                # ... then search for a default.ext file
                files = readDir filePath;
                defaultFiles = map (ext: "default.${ext}") extensions;
                hasDefault = any (defaultFile: files ? ${defaultFile}) defaultFiles;
              in
              # if it exists, add the directory to our file list
              if allowDefault && hasDefault then
                {
                  name = fileName;
                  value = filePath;
                }
              else
                # otherwise search recursively in the directory
                # and map the results to a nested set with the name of the folder as top key
                {
                  name = fileName;
                  value = findFilesRecursive filePath;
                }
            else
              # any other file types we ignore (i.e. symlink and unknown)
              ignore fileName
          ) (readDir dir)
        );
    in
    findFilesRecursive dir;

  # let
  #   findFilesInner =
  #     dir:
  #     concatLists (
  #       attrValues (
  #         mapAttrs (
  #           fileName: type:
  #           let
  #             extMatch = (match "(.*)\\.${extRegex}" fileName);
  #           in
  #           # If regular file, then add it to the file list only if the extension regex matches
  #           if type == "regular" then
  #             if extMatch == null then
  #               [ ]
  #             else
  #               [
  #                 {
  #                   name = elemAt extMatch 0;
  #                   value = dir + "/${fileName}";
  #                 }
  #               ]
  #           # If directory, ...
  #           else if type == "directory" then
  #             let
  #               # ... then search for a default.ext file
  #               files = readDir (dir + "/${fileName}");
  #               defaultFiles = map (ext: "default.${ext}") extensions;
  #               hasDefault = any (defaultFile: files ? ${defaultFile}) defaultFiles;
  #             in
  #             # if it exists, add the directory to our file list
  #             if allowDefault && hasDefault then
  #               [
  #                 {
  #                   name = fileName;
  #                   value = dir + "/${fileName}";
  #                 }
  #               ]
  #             else
  #               # otherwise search recursively in the directory
  #               # and map the results to a nested set with the name of the folder as top key
  #               [
  #                 {
  #                 name = fileName;
  #                 value = 
  #                 }
  #               ]
  #               map (
  #                 { name, value }:
  #                 {
  #                   name = fileName;
  #                   value = {
  #                     ${name} = value;
  #                   };
  #                 }
  #               ) (traceValSeq (findFilesInner (dir + "/${fileName}")))
  #           else
  #             # any other file types we ignore (i.e. symlink and unknown)
  #             [ ]
  #         ) (readDir dir)
  #       )
  #     );
  # in
  # listToAttrs (findFilesInner dir);

  # Shortcut to easily import whole directories structures
  importDirectory = path: mapAttrs (name: value: import value) (findFiles path [ "nix" ] false);

  # Function to create a nixos host config
  mkHost =
    {
      user,
      hostName,
      system,
      modules,
    }:
    nixosSystem {
      inherit system;
      modules = [ ./secrets.nix ] ++ modules;
      specialArgs = inputs // {
        # Constants
        inherit user system hostName;
        # Helper libs
        inherit directories findFiles importDirectory;
        scriptBin = scriptBin system;
      };
    };

}
