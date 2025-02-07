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
    desktop = {
      # Require fonts
      fonts.enable = true;

      defaultsApps.notes = lib.mkDefault "obsidian";
    };

    home-manager.users.${constants.user} = {
      home.packages = with pkgs; [
        obsidian
      ];
    };
  };
}
