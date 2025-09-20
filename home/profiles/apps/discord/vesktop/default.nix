{
  pkgs,
  lib2,
  ...
}:
let
  inherit (lib2.hm) mkSyncedPath;
in

# Relevant issues:
# https://github.com/Vencord/Vesktop/pull/609/
# https://github.com/Vencord/Vesktop/pull/326

{
  imports = [
    (mkSyncedPath {
      xdgDir = "config";
      target = "vesktop/settings/settings.json";
      syncName = "vesktop/vencord.json";
    })

    (mkSyncedPath {
      xdgDir = "config";
      target = "vesktop/settings.json";
      syncName = "vesktop/vesktop.json";
    })
  ];

  home.packages = [
    (pkgs.callPackage ./vesktop.nix { })
  ];

  home.shellAliases = {
    "discord" = "vesktop";
  };
}
