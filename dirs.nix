{ extra-libs, ... }:

let
  inherit (extra-libs) findFiles;
in

{
  modules = findFiles {
    dir = ./modules;
    extensions = [ "nix" ];
    defaultFiles = [ "default.nix" ];
  };
}
