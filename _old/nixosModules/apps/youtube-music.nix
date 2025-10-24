{
  pkgs,
  lib2,
  user,
  ...
}:
let
  inherit (lib2) mkSyncedPath;
in
{
  environment.systemPackages = with pkgs; [
    youtube-music
  ];

  imports = [
    (mkSyncedPath {
      xdgPath = "YouTube Music/config.json";
      cfgPath = "youtube-music/config.json";
    })
  ];
}
