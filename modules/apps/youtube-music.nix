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
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      youtube-music
    ];
  };

  imports = [
    (mkSyncedJSON {
      xdgPath = "YouTube Music/config.json";
      cfgPath = "youtube-music/config.json";
      modify = (
        file:
        file
        // {
          options = {
            themes = [
              # This explicitly copies the file to the nix store
              "${/. + "${dotsRepoPath}/config/youtube-music/theme.css"}"
            ];
          };
        }
      );
    })
  ];
}
