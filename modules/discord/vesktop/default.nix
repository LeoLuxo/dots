{
  lib,
  pkgs,
  constants,
  extra-libs,
  ...
}:

let
  inherit (constants) user;
  inherit (extra-libs) mkSyncedJSON quickPatch mkGlobalKeybind;
in

{
  imports = [
    ./icons.nix
    ./keybinds-fix.nix

    (quickPatch {
      package = "vencord";
      patches = [
        ./vencord_disable_update_check.patch
      ];
    })

    (quickPatch {
      package = "vesktop";
      patches = [
        ./vesktop_disable_update_check.patch

        # Vencord is being a little annoying so use our custom vencord and patch that to disable updates
        # (pkgs.substituteAll {
        #   src = ./use_custom_vencord.patch;
        #   inherit (pkgs) vencord;
        # })
      ];
    })

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

    (mkSyncedJSON {
      xdgPath = "vesktop/settings.json";
      cfgPath = "vesktop/vesktop.json";
    })

    (mkSyncedJSON {
      xdgPath = "vesktop/settings/settings.json";
      cfgPath = "vesktop/vencord.json";
    })
  ];

  defaultPrograms.communication = lib.mkDefault "vesktop";

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      (vesktop.override {
        withSystemVencord = true;
        inherit vencord;
      })
    ];
  };
}
