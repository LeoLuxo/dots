{ ... }:
{
  # Overlay to fix the bug where settimed doesn't work for the dark theme of gnome
  # https://github.com/xyproto/wallutils/issues/44
  # TODO: Remove when the issue gets fixed

  nixpkgs.overlays = [
    (final: prev: {
      wallutils = prev.wallutils.overrideAttrs (
        finalAttrs: oldAttrs: {

          # Find all concerned files via grep
          # And replace the corresponding line to ALSO set picture-uri-dark
          postPatch =
            let
              pre = ''return g.Set("picture-uri", "file://"+imageFilename)'';
              post = ''g.Set("picture-uri-dark", "file://"+imageFilename); '' + pre;
            in
            (oldAttrs.postPath or "")
            + ''
              grep -rl "picture-uri" . | xargs sed -i 's#${pre}#${post}#g'
            '';
        }
      );
    })
  ];
}
