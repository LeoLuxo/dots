{
  pkgs,
  config,
  extraLib,
  ...
}:
let
  inherit (extraLib) mkSyncedPath mkJSONMerge;
in
{
  my.packages = with pkgs; [
    youtube-music
  ];

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
