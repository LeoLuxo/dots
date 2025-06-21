{ constants, config, ... }:
{
  home-manager.users.${config.ext.system.user.name} =
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
}
