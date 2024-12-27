{
  lib,
  pkgs,
  constants,
  extra-libs,
  ...
}:

let
  inherit (constants) user;
  inherit (extra-libs) mkSyncedJSON mkQuickPatch mkGlobalKeybind;
in

{
  imports = [
    ./icons-and-name.nix
    ./keybinds-fix.nix

    (mkQuickPatch {
      package = "vencord";
      patches = [
        ./vencord-disable-update-check.patch
      ];
    })

    (mkQuickPatch {
      package = "vesktop";
      patches = [
        ./vesktop-disable-update-check.patch

        # Vencord is being a little annoying so use our custom vencord and patch that to disable updates
        # (pkgs.substituteAll {
        #   src = ./use-custom-vencord.patch;
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
