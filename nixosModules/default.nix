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
        let
          dirModules = recursivelyImportDir fullPath;
        in
        # Prepend the directory name to all the modules that were recursively imported from that dir
        lib.mapAttrs' (n: v: lib.nameValuePair ("${attrName}-${n}") v) dirModules
    ) (builtins.readDir path);

  modules = recursivelyImportDir ./.;
in

modules
// {
  # Make "default" a mega-module that auto-imports all the other modules
  default = {
    imports = lib.attrValues modules;
  };
}
