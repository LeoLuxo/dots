{ ... }:

{
  # Overlay to disable update checking
  nixpkgs.overlays = [
    (final: prev: {
      wallutils = prev.wallutils.overrideAttrs (
        finalAttrs: oldAttrs: {

          # Straight up return when trying to check update
          # Very cursed but very functional
          postPatch =
            let
              pre = ''export async function checkUpdates() {'';
              post = pre + ''return;'';
            in
            (oldAttrs.postPath or "")
            + ''
              sed -i 's#${pre}#${post}#g' "src/updater/main.ts"
            '';
        }
      );
    })
  ];
}
