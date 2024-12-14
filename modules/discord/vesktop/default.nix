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
      package = "vesktop";
      patches = [
        ./vesktop_disable_update_check.patch
      ];
    })

    (quickPatch {
      package = "vencord";
      patches = [
        ./vencord_disable_update_check.patch
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
      cfgPath = "vesktop/settings1.json";
    })

    (mkSyncedJSON {
      xdgPath = "vesktop/settings/settings.json";
      cfgPath = "vesktop/settings2.json";
    })
  ];

  defaultPrograms.communication = lib.mkDefault "vesktop";

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # Vencord is being a little annoying so use the system vencord and then patch it to disable updates
      (vesktop.override { withSystemVencord = true; })
      vencord
    ];
  };
}
