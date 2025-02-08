{
  cfg,
  lib,
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
    home-manager.users.${constants.user} =
      { config, ... }:
      {
        xdg.userDirs = {
          enable = true;
          createDirectories = true;

          download = "${config.home.homeDirectory}/downloads";

          music = "${config.home.homeDirectory}/media";
          pictures = "${config.home.homeDirectory}/media";
          videos = "${config.home.homeDirectory}/media";

          desktop = "${config.home.homeDirectory}/misc";
          documents = "${config.home.homeDirectory}/misc";
          publicShare = "${config.home.homeDirectory}/misc";
          templates = "${config.home.homeDirectory}/misc";
        };
      };
  };
}
