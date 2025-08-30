{ user, ... }:

let
  home = "/home/${user}";
in
{
  imports = [ ./agenix.nix ];

  # Do not change
  home.stateVersion = "24.05";

  # Home Manager needs a bit of information about you and the paths it should manage.
  home = {
    username = user;
    homeDirectory = home;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Customize default directories
  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    download = "${home}/downloads";

    music = "${home}/media";
    pictures = "${home}/media";
    videos = "${home}/media";

    desktop = "${home}/misc";
    documents = "${home}/misc";

    templates = null;
    publicShare = null;
  };
}
