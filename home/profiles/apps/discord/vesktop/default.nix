{
  pkgs,
  lib2,
  ...
}:
let
  inherit (lib2) mkSyncedPath;
in

# Relevant issues:
# https://github.com/Vencord/Vesktop/pull/609/
# https://github.com/Vencord/Vesktop/pull/326

{
  imports = [
    # (mkSyncedPath {
    #   xdgPath = "vesktop/settings/settings.json";
    #   cfgPath = "vesktop/vencord.json";
    # })

    # (mkSyncedPath {
    #   xdgPath = "vesktop/settings.json";
    #   cfgPath = "vesktop/vesktop.json";
    # })
  ];

  home.packages = [
    (pkgs.callPackage ./vesktop.nix { })
  ];

  home.shellAliases = {
    "discord" = "vesktop";
  };
}
