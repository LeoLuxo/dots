{
  lib,
  outputs,
  ...
}:
let
  lib2 = outputs.lib;
in

# {
#   default = lib2.recursivelyImportDirToList ./.;
# }
# //
(lib2.recursivelyImportDir ./.)

# {
#   test = { };
# }
