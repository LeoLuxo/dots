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
    desktop.keybinds."Instant translate" = {
      binding = "<Super>d";
      command = "dialect --selection";
    };

    home-manager.users.${constants.user} = {
      home.packages = with pkgs; [
        # Gnome circles translator app
        dialect
      ];
    };
  };
}
