final: prev:

{
  lib2 = {
    paths = import ./paths.nix;
    options = import ./options.nix;
    strings = import ./strings.nix;
  };
}
