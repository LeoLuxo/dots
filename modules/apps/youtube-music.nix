{
  pkgs,
  constants,
  extra-libs,
  ...
}:
let
  inherit (constants) user;
  inherit (extra-libs) mkSyncedMergedJSON;
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
