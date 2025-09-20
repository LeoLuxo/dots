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
      target = "~/.config/vesktop/settings/settings.json";
      syncName = "vesktop/vencord.json";
    })

    (mkSyncedPath {
      target = "~/.config/vesktop/settings.json";
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
