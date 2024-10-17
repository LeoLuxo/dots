{ ... }:
{
  # Overlay to fix gnome not being recognized while inside systemd because I can't be arsed to figure out how to do it correctly

  nixpkgs.overlays = [
    (final: prev: {
      wallutils = prev.wallutils.overrideAttrs (
        finalAttrs: oldAttrs: {

          # Find all concerned files via grep
          # And replace the corresponding line to ALSO set picture-uri-dark
          postPatch =
            let
              pre1 = ''func (g3 *Gnome3) ExecutablesExists() bool {'';
              post1 = pre1 + ''return true;'';

              pre2 = ''func (g3 *Gnome3) ExecutablesExists() bool {'';
              post2 = pre2 + ''return true;'';
            in
            (oldAttrs.postPath or "")
            + ''
              sed -i 's#${pre1}#${post1}#g' gnome3.go
              sed -i 's#${pre2}#${post2}#g' gnome3.go
            '';
        }
      );
    })
  ];
}
