{
  pkgs,
  constants,
  extra-libs,
  ...
}:
let
  inherit (constants) user dotsRepoPath;
  inherit (extra-libs) mkSyncedJSON;
in
{
  imports = [
    (mkSyncedJSON {
      syncPath = "youtube-music/config.json";
      xdgPath = "YouTube Music/config.json";
    })
  ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      youtube-music
    ];

    xdg.configFile."Youtube Music/theme.css".source = "${dotsRepoPath}/synced/youtube-music/theme.css";
  };
}
