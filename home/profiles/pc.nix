{ homeProfiles, lib2, ... }:

let
  inherit (lib2) mkGlobalKeybind;
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

    (mkGlobalKeybind {
      name = "Open terminal";
      binding = "<Super>grave";
      # Makes ddterm appear
      command = "gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/ddterm --method com.github.amezin.ddterm.Extension.Toggle";
    })

    (mkGlobalKeybind {
      name = "Open backup terminal";
      binding = "<Super>t";
      # Default gnome console
      command = "kgx";
    })

    (mkGlobalKeybind {
      name = "Open web browser";
      binding = "<Super>F1";
      command = "firefox";
    })

    (mkGlobalKeybind {
      name = "Open notes";
      binding = "<Super>F2";
      command = "obsidian";
    })

    (mkGlobalKeybind {
      name = "Open code editor";
      binding = "<Super>F3";
      command = "code";
    })

    (mkGlobalKeybind {
      name = "Open communication";
      binding = "<Super>F4";
      command = "vesktop";
    })
  ];

  # Set VSCode as default text editor
  home.sessionVariables = {
    "EDITOR" = "code";
  };

}
