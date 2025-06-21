{
  constants,
  config,
  pkgs,
  ...
}:

{
  ext.packages = [
    pkgs.steam-rom-manager
  ];

  home-manager.users.${config.ext.system.user.name} =
    { config, ... }:
    {
      xdg.configFile."steam-rom-manager/userData".source =
        config.lib.file.mkOutOfStoreSymlink "/stuff/games/roms/.srm/userData";
    };
}
