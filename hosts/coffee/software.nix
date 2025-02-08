{
  pkgs,
  constants,
  inputs,
  ...
}:

{

  # Extra packages that don't necessarily need an entire dedicated module
  home-manager.users.${constants.user}.home.packages = with pkgs; [
    guitarix # A virtual guitar amplifier for Linux.
    r2modman # A mod manager for Risk of Rain 2 and other Unity games.
  ];

  scripts.boot-windows.enable = true;

  apps = {
    distrobox.enable = true;
    llm.enable = true;
    qmk.enable = true;
  };

  wallpaper.image = inputs.wallpapers.static."flowers";

}
