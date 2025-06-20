{
  constants,
  pkgs,
  ...
}:

let
  inherit (constants) user;
in

{
  home-manager.users.${user} =
    { config, ... }:
    {
      home.packages = [
        pkgs.steam-rom-manager
      ];

      xdg.configFile."steam-rom-manager/userData".source =
        config.lib.file.mkOutOfStoreSymlink "/stuff/games/roms/.srm/userData";
    };
}
