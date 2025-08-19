{ lib, ... }:

let
  recursivelyImportDir =
    path:
    lib.concatMapAttrs (
      name: type:
      let
        attrName = lib.removePrefix "_" (lib.removeSuffix ".nix" name);
        fullPath = path + "/${name}";
        isDefault = name == "default.nix";
        isFile = type == "regular";
        isDirWithDefault = type == "directory" && lib.pathExists (fullPath + "/default.nix");
      in
      if isDefault then
        # The path itself is a default.nix file: don't import anything (it should be imported as a directory instead)
        { }
      else if isFile || isDirWithDefault then
        # Either the path is a file or it is a directory which contains a default.nix file: directly import it as a module
        { ${attrName} = import fullPath; }
      else
        # The path is a simple directory: recursively import its contents
        { ${attrName} = recursivelyImportDir fullPath; }
    ) (builtins.readDir path);

  modules = recursivelyImportDir ./.;
in

modules
