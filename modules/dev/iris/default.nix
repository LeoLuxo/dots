{
  pkgs,
  user,
  directories,
  lib,
  ...
}:
{
  imports = with directories.modules; [ dev.coq ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      iris-coq
    ];
  };

  nixpkgs.overlays = [
    (final: prev: {

      # Add Iris derivation
      iris-coq = pkgs.coqPackages.callPackage ./iris-coq.nix { };

    })
  ];
}
