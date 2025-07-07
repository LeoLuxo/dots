{
  constants,
  config,
  pkgs,
  ...
}:

{
  my.packages = [
    pkgs.steam-rom-manager
  ];

  my.symlinks.xdgData."steam-rom-manager/userData" = "/stuff/games/roms/.srm/userData";
  # home-manager.users.${config.my.user.name} =
  #   { config, ... }:
  #   {
  #     xdg.configFile."steam-rom-manager/userData".source =
  #       config.lib.file.mkOutOfStoreSymlink "/stuff/games/roms/.srm/userData";
  #   };
}
