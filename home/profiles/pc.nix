{
  pkgs,
  homeProfiles,
  lib2,
  ...
}:

let
  inherit (lib2.hm) mkGlobalKeybind;
in
{
  imports = [
    homeProfiles.base
    homeProfiles.gnome

    homeProfiles.common.fonts

    homeProfiles.scripts.clipboard
    homeProfiles.scripts.snip

    homeProfiles.scripts.dots
    homeProfiles.scripts.dotsTodo
    homeProfiles.scripts.dconfDiff

    homeProfiles.apps.direnv
    homeProfiles.apps.firefox
    homeProfiles.apps.obsidian
    homeProfiles.apps.vscode
    homeProfiles.apps.zoxide

    (mkGlobalKeybind {
      name = "Open terminal";
      binding = "<Super>grave";
      command = "$APP_TERMINAL";
    })

    (mkGlobalKeybind {
      name = "Open backup terminal";
      binding = "<Super>t";
      command = "$APP_TERMINAL_BACKUP";
    })

    (mkGlobalKeybind {
      name = "Open web browser";
      binding = "<Super>F1";
      command = "$APP_BROWSER";
    })

    (mkGlobalKeybind {
      name = "Open notes";
      binding = "<Super>F2";
      command = "$APP_NOTES";
    })

    (mkGlobalKeybind {
      name = "Open code editor";
      binding = "<Super>F3";
      command = "$APP_CODE_EDITOR";
    })

    (mkGlobalKeybind {
      name = "Open communication";
      binding = "<Super>F4";
      command = "$APP_COMMUNICATION";
    })

    # (mkSyncedPath {
    #   xdgPath = "YouTube Music/config.json";
    #   cfgPath = "youtube-music/config.json";
    # })
  ];

  home.packages = [
    pkgs.bitwarden-desktop
    pkgs.youtube-music
  ];

}
