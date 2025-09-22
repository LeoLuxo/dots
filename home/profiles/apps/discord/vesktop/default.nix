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
    pkgs.vesktop
  ];

  nixpkgs.overlays = [
    (final: prev: {
      # vesktop = (prev.callPackage ./vesktop-1.5.8-patch326.nix { });
      vesktop = (prev.callPackage ./vesktop-1.5.5-patch609.nix { });
    })

    (import ./overlays/customIcons.nix)
  ];

  home.shellAliases = {
    "discord" = "vesktop";
  };
}
