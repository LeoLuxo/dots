{
  constants,
  pkgs,
  ...
}:

let
  inherit (constants) user;
in

{
  ext.packages = [
    pkgs.steam-rom-manager
  ];

  home-manager.users.${user} =
    { config, ... }:
    {
      xdg.configFile."steam-rom-manager/userData".source =
        config.lib.file.mkOutOfStoreSymlink "/stuff/games/roms/.srm/userData";
    };
}
