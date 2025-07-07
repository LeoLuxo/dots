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

  my.symlinks.xdgConfig."steam-rom-manager/userData" = "/stuff/games/roms/.srm/userData";
}
