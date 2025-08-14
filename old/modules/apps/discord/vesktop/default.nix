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

{
  imports = [
    ./overlays/customIconsAndName.nix
    ./overlays/globalKeybinds.nix

    # (mkQuickPatch {
    #   package = "vencord";
    #   patches = [
    #     ./patches/vencord-disable-update-check.patch
    #   ];
    # })

    # (mkQuickPatch {
    #   package = "vesktop";
    #   patches = [
    #     ./patches/vesktop-disable-update-check.patch

    #     # Vencord is being a little annoying so use our custom vencord and patch that to disable updates
    #     # (pkgs.substituteAll {
    #     #   src = ./patches/use-custom-vencord.patch;
    #     #   inherit (pkgs) vencord;
    #     # })
    #   ];
    # })

    (mkSyncedPath {
      xdgPath = "vesktop/settings/settings.json";
      cfgPath = "vesktop/vencord.json";
    })

    (mkSyncedPath {
      xdgPath = "vesktop/settings.json";
      cfgPath = "vesktop/vesktop.json";
    })
  ];

  my.defaultApps.communication = lib.mkDefault "vesktop";

  my.packages = with pkgs; [
    (vesktop.override {
      withSystemVencord = true;
      inherit vencord;
    })
  ];

  my.keybinds = {
    "Discord mute" = {
      binding = "<Super>m";
      command = "echo \"VCD_TOGGLE_SELF_MUTE\" >> $XDG_RUNTIME_DIR/vesktop-ipc";
    };

    "Discord deafen" = {
      binding = "<Super><Shift>m";
      command = "echo \"VCD_TOGGLE_SELF_DEAF\" >> $XDG_RUNTIME_DIR/vesktop-ipc";
    };
  };
}
