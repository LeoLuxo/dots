args@{ lib2, ... }:

lib2.recursivelyImportDir {
  path = ./.;
  inherit args;
}
