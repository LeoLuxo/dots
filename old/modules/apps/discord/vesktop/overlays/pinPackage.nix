{ ... }:

let

  # TODO: Make this into a lib
  overlay =
    final: prev:
    let
      pinnedPkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/5b328f10f58c0cd5c0647dc2efa6b4655a897082.tar.gz";
      }) { };
    in
    {
      vesktop = pinnedPkgs.vesktop;
    };
in
{
  nixpkgs.overlays = [ overlay ];
}
