{ pkgs, ... }:

let
  mutterTripleBuffering = pkgs.fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "vanvugt";
    repo = "mutter";
    rev = "triple-buffering-v4-47";
    hash = "sha256-ajxm+EDgLYeqPBPCrgmwP+FxXab1D7y8WKDQdR95wLI=";
  };

  gvdb = pkgs.fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gvdb";
    rev = "main";
    hash = "sha256-CIdEwRbtxWCwgTb5HYHrixXi+G+qeE1APRaUeka3NWk=";
  };
in

{
  nixpkgs.overlays = [
    # GNOME 47: triple-buffering-v4-47
    (final: prev: {
      mutter = prev.mutter.overrideAttrs (old: {
        src = mutterTripleBuffering;

        preConfigure = ''
          cp -a "${gvdb}" ./subprojects/gvdb
        '';
      });
    })
  ];

}
