{
  pkgs,
  lib,
  lib2,
  user,
  ...
}:

let
  inherit (lib2.nixos) mkKeybind mkSyncedPath;
in

# Relevant issues:
# https://github.com/Vencord/Vesktop/pull/326
# https://github.com/Vencord/Vesktop/pull/609

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

    (mkKeybind {
      name = "Discord mute";
      binding = "<Super>m";
      command = "echo \"VCD_TOGGLE_SELF_MUTE\" >> $XDG_RUNTIME_DIR/vesktop-ipc";
    })

    (mkKeybind {
      name = "Discord deafen";
      binding = "<Super><Shift>m";
      command = "echo \"VCD_TOGGLE_SELF_DEAF\" >> $XDG_RUNTIME_DIR/vesktop-ipc";
    })

  ];

  home-manager.users.${user} = {
    home.shellAliases = {
      "discord" = "vesktop";
    };

    # Set discord as the default communication app
    home.sessionVariables = {
      APP_COMMUNICATION = lib.mkDefault "vesktop";
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      # vesktop = (final.pinned.callPackage ./vesktop-1.5.8-patch326.nix { });
      vesktop = (
        final.pinned.callPackage ./vesktop-1.5.5-patch609.nix {
          withSystemVencord = true;
          vencord = pkgs.unstable.vencord;
        }
      );
    })

    (import ./overlays/customIcons.nix)
  ];

  environment.systemPackages = [
    pkgs.vesktop
  ];
}
