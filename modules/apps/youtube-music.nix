{
  pkgs,
  constants,
  ...
}:
let
  inherit (constants) user;
in
{
  config = {
    syncedPaths."youtube-music/config.json" = {
      xdgPath = "YouTube Music/config.json";
      type = "json";
      overrides = {
        options.themes = [ ];
      };
    };

    home-manager.users.${constants.user} = {
      home.packages = with pkgs; [
        youtube-music
      ];
    };
  };
}
