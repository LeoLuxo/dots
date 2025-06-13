{
  lib,
  pkgs,
  constants,
  extraLib,
  ...
}:

let
  inherit (constants) user;
  inherit (extraLib)
    mkQuickPatch
    mkGlobalKeybind
    mkJSONMerge
    mkSyncedPath
    ;
in

{
  imports = [
    ./overlays/customIconsAndName.nix
    ./overlays/pinPackage.nix
    ./overlays/globalKeybinds.nix
    # ./keybindsFixOld.nix

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

    (mkGlobalKeybind {
      name = "Discord mute";
      binding = "<Super>m";
      command = "echo \"VCD_TOGGLE_SELF_MUTE\" >> $XDG_RUNTIME_DIR/vesktop-ipc";
    })

    (mkGlobalKeybind {
      name = "Discord deafen";
      binding = "<Super><Shift>m";
      command = "echo \"VCD_TOGGLE_SELF_DEAF\" >> $XDG_RUNTIME_DIR/vesktop-ipc";
    })

    (mkSyncedPath {
      xdgPath = "vesktop/settings.json";
      cfgPath = "vesktop/vesktop.json";
      merge = mkJSONMerge { };
    })

    (mkSyncedPath {
      xdgPath = "vesktop/settings/settings.json";
      cfgPath = "vesktop/vencord.json";
      merge = mkJSONMerge {
        defaultOverrides = {
          themeLinks = [ ];
        };
      };
    })
  ];

  defaults.apps.communication = lib.mkDefault "vesktop";

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      (vesktop.override {
        withSystemVencord = true;
        inherit vencord;
      })
    ];
  };
}
