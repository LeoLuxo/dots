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
    homeProfiles.apps.discord
    homeProfiles.apps.firefox
    homeProfiles.apps.obsidian
    homeProfiles.apps.upscaler
    homeProfiles.apps.vscode

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
  ];

  home.packages = [
    pkgs.bitwarden-desktop # Deskstop app for bitwarden
    pkgs.commit # Gnome commit editor
    pkgs.textpieces # A developer’s scratchpad that lets you quickly experiment with and transform text.
    pkgs.hieroglyphic # An application that helps you locate and select LaTeX symbols by drawing or sketching them.
    pkgs.impression # A utility for creating bootable USB drives from disk images.
    pkgs.switcheroo # A tool for converting and manipulating images (for example, resizing or reformatting them).
    pkgs.video-trimmer # A simple app designed to quickly trim and edit video clips.
    pkgs.warp # A fast, secure file transfer utility for moving files efficiently between systems.
    pkgs.upscaler # An application that enhances image resolution by upscaling photos using advanced processing (designed in the GNOME spirit).
    pkgs.eyedropper # A simple color picker tool that allows you to select a color from anywhere on the screen.
    pkgs.celluloid # A simple video player

    # pkgs.teams-for-linux # Microsoft Teams client recreated, the original electron teams package was abandoned
    # pkgs.gnome-2048 # A GNOME-native implementation of the popular 2048 puzzle game.
  ];

  # Set the commit editor to gnome commit
  programs.git.extraConfig.core.editor = "re.sonny.Commit";

}
