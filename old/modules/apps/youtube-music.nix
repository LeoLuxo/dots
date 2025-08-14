{
  pkgs,
  lib2,
  ...
}:
let
  inherit (lib2) mkSyncedPath;
in
{
  my.packages = with pkgs; [
    youtube-music
  ];

  imports = [
    (mkSyncedPath {
      xdgPath = "YouTube Music/config.json";
      cfgPath = "youtube-music/config.json";
    })
  ];
}
