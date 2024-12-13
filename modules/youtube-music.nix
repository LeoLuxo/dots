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
      cfgPath = "youtube-music/config.json";
      xdgPath = "YouTube Music/config.json";
      modify = (
        file:
        file
        // {
          options = {
            themes = [
              "${/. + "${dotsRepoPath}/config/youtube-music/theme.css"}"
            ];
          };
        }
      );
    })
  ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      youtube-music
    ];

    # xdg.configFile."YouTube Music/theme.css".source = "${dotsRepoPath}/config/youtube-music/theme.css";
  };
}
