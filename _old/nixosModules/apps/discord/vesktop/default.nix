{
  pkgs,
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

  home-manager.users.${user}.home.shellAliases = {
    "discord" = "vesktop";
  };

  environment.systemPackages = [ pkgs.vesktop ];

  nixpkgs.overlays = [
    (final: prev: {
      # vesktop = (prev.callPackage ./vesktop-1.5.8-patch326.nix { });
      vesktop = (prev.callPackage ./vesktop-1.5.5-patch609.nix { });
    })

    (import ./overlays/customIcons.nix)
  ];

}
