{ ... }:

{
  # Overlay to disable update checking
  nixpkgs.overlays = [
    (final: prev: {
      vesktop = prev.vesktop.overrideAttrs (
        finalAttrs: oldAttrs: {

          # Disable the updater for vesktop
          postPatch =
            let
              patch1 = {
                pre = ''autoUpdater.checkForUpdatesAndNotify();'';
                post = '''';
              };
              patch2 = {
                pre = ''import { autoUpdater } from "electron-updater";'';
                post = '''';
              };
            in
            (oldAttrs.postPatch or "")
            + ''
              sed -i 's#${patch1.pre}#${patch1.post}#g' "src/main/index.ts"
              sed -i 's#${patch2.pre}#${patch2.post}#g' "src/main/index.ts"
            '';
        }
      );
    })
  ];
}
