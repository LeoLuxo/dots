{
  lib,
  pkgs,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  imports = [
    ./icons-and-name.nix
    ./keybinds-fix.nix
  ];

  config = {
    quickPatches = {
      "vencord" = [
        ./vencord-disable-update-check.patch
      ];

      "vesktop" = [
        ./vesktop-disable-update-check.patch

        # Vencord is being a little annoying so use our custom vencord and patch that to disable updates
        # (pkgs.substituteAll {
        #   src = ./use-custom-vencord.patch;
        #   inherit (pkgs) vencord;
        # })
      ];
    };

    syncedPaths = {
      "vesktop/vesktop.json" = {
        xdgPath = "vesktop/settings.json";
        type = "json";
      };

      "vesktop/vencord.json" = {
        xdgPath = "vesktop/settings/settings.json";
        type = "json";
        overrides = {
          themeLinks = [ ];
        };
      };
    };

    desktop.keybinds = {
      "Discord mute" = {
        binding = "<Super>m";
        command = "echo \"VCD_TOGGLE_SELF_MUTE\" >> $XDG_RUNTIME_DIR/vesktop-ipc";
      };

      "Discord deafen" = {
        binding = "<Super><Shift>m";
        command = "echo \"VCD_TOGGLE_SELF_DEAF\" >> $XDG_RUNTIME_DIR/vesktop-ipc";
      };
    };

    defaults.apps.communication = lib.mkDefault "vesktop";

    home-manager.users.${user} = {
      home.packages = with pkgs; [
        # (vesktop.override {
        #   withSystemVencord = true;
        #   inherit vencord;
        # })
        vesktop
      ];
    };
  };

}
