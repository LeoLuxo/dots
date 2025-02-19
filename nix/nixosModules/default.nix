{ lib, ... }:

let
  # recursivelyImportDir =
  #   path:
  #   lib.genAttrs
  #     (lib.traceValSeq (
  #       lib.pipe (builtins.readDir (lib.traceVal path)) [
  #         lib.traceVal
  #         lib.attrNames
  #         (lib.filter (s: s != "default.nix"))
  #         # (lib.filter (s: (lib.hasSuffix ".nix" s) || lib.pathExists (path + "/${s}/default.nix")))
  #         (map (lib.removeSuffix ".nix"))
  #         (map (lib.removePrefix "_"))
  #       ]
  #     ))
  #     (
  #       p:
  #       let
  #         file = path + "/${p}.nix";
  #         underscoreFile = path + "/_${p}.nix";
  #         dir = path + "/${p}";
  #         defaultFile = dir + "/default.nix";
  #       in
  #       if lib.traceVal (lib.pathExists file) then
  #         import file
  #       else if lib.traceVal (lib.pathExists underscoreFile) then
  #         import underscoreFile
  #       else if lib.traceVal (lib.pathExists defaultFile) then
  #         import dir
  #       else
  #         recursivelyImportDir dir
  #     );

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
        lib.mapAttrs' (n: v: lib.nameValuePair ("${attrName}-${n}") v) (recursivelyImportDir fullPath)
    ) (builtins.readDir path);

  modules = recursivelyImportDir ./.;
  combinedModules = lib.attrValues modules;
in

modules
// {
  default = {
    imports = combinedModules;
  };
}
