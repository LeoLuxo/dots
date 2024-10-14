{
  lib,
  user,
  directories,
  ...
}:

{
  home-manager.users.${user} = {
    xdg = {
      enable = true;

      # Symlink all static wallpapers into the gnome wallpaper directory
      # ~/.local/share/backgrounds
      dataFile."test".source = lib.traceValSeq directories.images.wallpapers._dir;
    };
  };
}
