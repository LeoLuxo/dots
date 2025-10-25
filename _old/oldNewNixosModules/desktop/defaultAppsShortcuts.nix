{
  lib,
  lib2,
  config,
  ...
}:

let
  cfg = config.my.desktop.defaultAppsShortcuts;
in
{
  imports = [
    (lib2.nixos.mkKeybind {
      name = "Open terminal";
      binding = "<Super>grave";
      command = config.my.defaultApps.terminal;
    })

    (lib2.nixos.mkKeybind {
      name = "Open backup terminal";
      binding = "<Super>t";
      command = config.my.defaultApps.backupTerminal;
    })

    (lib2.nixos.mkKeybind {
      name = "Open web browser";
      binding = "<Super>F1";
      command = config.my.defaultApps.browser;
    })

    (lib2.nixos.mkKeybind {
      name = "Open notes";
      binding = "<Super>F2";
      command = config.my.defaultApps.notes;
    })

    (lib2.nixos.mkKeybind {
      name = "Open code editor";
      binding = "<Super>F3";
      command = config.my.defaultApps.codeEditor;
    })

    (lib2.nixos.mkKeybind {
      name = "Open communication";
      binding = "<Super>F4";
      command = config.my.defaultApps.communication;
    })
  ];

  options.my.desktop.defaultAppsShortcuts = {
    enable = lib.mkEnableOption "the default apps shortcuts";
  };

  config = lib.mkIf cfg.enable {
  };
}
