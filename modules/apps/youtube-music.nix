{
  pkgs,
  constants,
  extraLib,
  ...
}:
let
  inherit (constants) user;
  inherit (extraLib) mkSyncedPath mkJSONMerge;
in
{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      youtube-music
    ];
  };

  imports = [
    (mkSyncedPath {
      xdgPath = "YouTube Music/config.json";
      cfgPath = "youtube-music/config.json";
      merge = mkJSONMerge {
        defaultOverrides = {
          options.themes = [ ];
        };
      };
    })
  ];
}
