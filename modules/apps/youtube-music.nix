{
  pkgs,
  constants,
  extraLib,
  ...
}:
let
  inherit (constants) user;
  inherit (extraLib) mkSyncedMergedJSON;
in
{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      youtube-music
    ];
  };

  imports = [
    (mkSyncedMergedJSON {
      xdgPath = "YouTube Music/config.json";
      cfgPath = "youtube-music/config.json";
      defaultOverrides = {
        options.themes = [ ];
      };
    })
  ];
}
