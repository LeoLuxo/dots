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
        { }
      else if isFile || isDirWithDefault then
        { ${attrName} = import fullPath; }
      else
        # Prepend the directory name to all the modules that were recursively imported from that dir
        lib.mapAttrs' (n: v: lib.nameValuePair ("${attrName}-${n}") v) (recursivelyImportDir fullPath)
    ) (builtins.readDir path);

  modules = recursivelyImportDir ./.;
in

modules
# // {
#   # Make "default" a mega-module that auto-imports all the other modules
#   default = {
#     imports = lib.attrValues modules;
#   };
# }
