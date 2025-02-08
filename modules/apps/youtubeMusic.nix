{
  config,
  lib,
  pkgs,

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
    syncedPaths."youtubeMusic/config.json" = {
      xdgPath = "YouTube Music/config.json";
      type = "json";
      overrides = {
        options.themes = [ ];
      };
    };

    home-manager.users.${constants.user} = {
      home.packages = with pkgs; [
        youtubeMusic
      ];
    };
  };
}
