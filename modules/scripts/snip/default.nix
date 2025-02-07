{
  cfg,
  lib,
  pkgs,
  extraLib,
  constants,
  ...
}:

let
  inherit (lib) modules;
  inherit (extraLib) mkEnable;
in
{
  options = {
    enable = mkEnable;
  };

  config = modules.mkIf cfg.enable {
    desktop.keybinds."Instant screenshot" = {
      binding = "<Super>s";
      command = "snip";
    };

    home-manager.users.${constants.user} = {
      home.packages = with pkgs; [
        (writeScriptWithDeps {
          name = "snip";
          file = ./snip.sh;
          deps = [
            gnome-screenshot
            wl-clipboard
          ];
        })
      ];
    };
  };
}
