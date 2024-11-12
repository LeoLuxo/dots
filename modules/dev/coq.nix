{ pkgs, user, ... }:
{
  imports = [ ];
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      ocamlPackages.findlib

      coq
      coqPackages.vscoq-language-server
    ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      # Add vscoq language server (for some reason can't fetch the one from nixpkgs?)
      # vscoq-language-server = pkgs.callPackage ./vscoq-language-server.nix { };

      coqPackages = pkgs.mkCoqPackages pkgs.coq_8_19;
    })
  ];
}
