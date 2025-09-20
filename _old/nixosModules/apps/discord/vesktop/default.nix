{
  lib,
  pkgs,
  lib2,
  ...
}:

let
  inherit (lib2)
    # mkQuickPatch
    mkSyncedPath
    ;
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

  my.defaultApps.communication = lib.mkDefault "vesktop";

  my.packages = [
    (pkgs.callPackage ./vesktop.nix { })
  ];

  # my.keybinds = {
  #   "Discord mute" = {
  #     binding = "<Super>m";
  #     command = "echo \"VCD_TOGGLE_SELF_MUTE\" >> $XDG_RUNTIME_DIR/vesktop-ipc";
  #   };

  #   "Discord deafen" = {
  #     binding = "<Super><Shift>m";
  #     command = "echo \"VCD_TOGGLE_SELF_DEAF\" >> $XDG_RUNTIME_DIR/vesktop-ipc";
  #   };
  # };
}
